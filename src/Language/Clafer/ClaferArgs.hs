{-
 Copyright (C) 2012 Kacper Bak, Jimmy Liang <http://gsd.uwaterloo.ca>

 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
-}
{-# LANGUAGE DeriveDataTypeable #-}
module Language.Clafer.ClaferArgs where

import System.IO ( stdin, hGetContents )
import System.Console.CmdArgs
import System.Console.CmdArgs.Explicit hiding (mode)
import Data.List
import Data.Maybe
import Control.Monad
	
import Language.Clafer.SplitJoin
import Language.Clafer.Version

data ClaferMode = Alloy42 | Alloy | Xml | Clafer | Html | Graph | CVLGraph
  deriving (Eq, Show, Data, Typeable)

data ClaferArgs = ClaferArgs {
      mode :: Maybe ClaferMode,
      console_output :: Maybe Bool,
      flatten_inheritance :: Maybe Bool,
      timeout_analysis :: Maybe Int,
      no_layout :: Maybe Bool,
      new_layout :: Maybe Bool,
      check_duplicates :: Maybe Bool,
      skip_resolver :: Maybe Bool,
      keep_unused :: Maybe Bool,
      no_stats :: Maybe Bool,
      schema :: Maybe Bool,
      validate :: Maybe Bool,
      noalloyruncommand :: Maybe Bool,
      tooldir :: Maybe FilePath,
      alloy_mapping :: Maybe Bool,
      self_contained :: Maybe Bool,
      add_graph :: Maybe Bool,
      show_references :: Maybe Bool,
      add_comments :: Maybe Bool,
      ecore2clafer :: Maybe Bool,      
      file :: FilePath
    } deriving (Show, Data, Typeable)

clafer = ClaferArgs {
  mode                = def &= help "Generated output type. Available CLAFERMODEs are: 'alloy' (default, Alloy 4.1); 'alloy42' (Alloy 4.2); 'xml' (intermediate representation of Clafer model); 'clafer' (analyzed and desugared clafer model); 'html' (original model in HTML); 'graph' (graphical representation written in DOT language); 'cvlgraph' (cvl notation representation written in DOT language)" &= name "m",
  console_output      = def &= help "Output code on console" &= name "o",
  flatten_inheritance = def &= help "Flatten inheritance ('alloy' and 'alloy42' modes only)" &= name "i",
  timeout_analysis    = def &= help "Timeout for analysis",
  no_layout           = def &= help "Don't resolve off-side rule layout" &= name "l",
  new_layout          = def &= help "Use new fast layout resolver (experimental)" &= name "nl",
  check_duplicates    = def &= help "Check duplicated clafer names"  &= name "c",
  skip_resolver       = def &= help "Skip name resolution" &= name "f",
  keep_unused         = def &= help "Keep uninstantated abstract clafers ('alloy' and 'alloy42' modes only)" &= name "k",
  no_stats            = def &= help "Don't print statistics" &= name "s",
  schema              = def &= help "Show Clafer IR (intermediate representation) XML schema",
  validate            = def &= help "Validate output. Uses 'tools/XsdCheck.class' for XML,  'tools/alloy4.jar' and 'tools/alloy4.2.jar' for Alloy models, and Clafer translator for desugared Clafer models. Use '--tooldir' to override the default location of these tools." &= name "v",
  noalloyruncommand   = def &= help "For usage with partial instances: Don't generate the alloy 'run show for ... ' command, and rename @.ref with unique names  ('alloy' and 'alloy42' modes only)" &= name "nr",
  tooldir             = def &= typDir &= help "Specify the tools directory ('validate' only). Default: 'tools/' ",
  alloy_mapping       = def &= help "Generate mapping to Alloy source code ('alloy' and 'alloy42' modes only)" &= name "a",
  self_contained      = def &= help "Generate a self-contained html document ('html' mode only)",
  add_graph           = def &= help "Add a graph to the generated html model ('html' mode only). Requires the \"dot\" executable to be on the system path.",
  show_references     = def &= help "Whether the links for references should be rendered. ('html' and 'graph' modes only)." &= name "sr",
  add_comments        = def &= help "Include comments from the source file in the html output ('html' mode only).",
  ecore2clafer        = def &= help "Translate an ECore model into Clafer.",
  file                = def &= args   &= typ "FILE"
 } &= summary ("Clafer " ++ version) &= program "clafer"

mainArgs = do
  args <- cmdArgs clafer
  model <- case file args of
             "" -> hGetContents stdin
             f  -> readFile f
  let firstLine = case lines model of
               [] -> ""
               (s:_) -> s
  let options = fromMaybe "" $ stripPrefix "//# OPTIONS " firstLine
  return $ (setDefArgs $
           either (\_ -> args) (\x -> mergeArgs args (cmdArgsValue x)) $
           process (cmdArgsMode clafer) $ Language.Clafer.SplitJoin.splitArgs options, model)

-- merges console arguments with pragmas in clafer models.
-- Console arguments have higher priority.
mergeArgs args args'  = args' {
  mode                = mode args                `mplus` mode args',
  console_output      = console_output args      `mplus` console_output args',
  flatten_inheritance = flatten_inheritance args `mplus` flatten_inheritance args',
  timeout_analysis    = timeout_analysis args    `mplus` timeout_analysis args',
  no_layout           = no_layout args           `mplus` no_layout args',
  new_layout          = new_layout args          `mplus` new_layout args',
  check_duplicates    = check_duplicates args    `mplus` check_duplicates args',
  skip_resolver       = skip_resolver args       `mplus` skip_resolver args',
  keep_unused         = keep_unused args         `mplus` keep_unused args',
  no_stats            = no_stats args            `mplus` no_stats args',
  schema              = schema args              `mplus` schema args',
  validate            = validate args            `mplus` validate args',
  noalloyruncommand   = noalloyruncommand args   `mplus` noalloyruncommand args',
  tooldir             = tooldir args             `mplus` tooldir args',
  alloy_mapping       = alloy_mapping args       `mplus` alloy_mapping args',
  self_contained      = self_contained args      `mplus` self_contained args',
  add_graph           = add_graph args           `mplus` add_graph args',
  show_references     = show_references args     `mplus` show_references args',  
  add_comments        = add_comments args        `mplus` add_comments args',
  ecore2clafer        = ecore2clafer args        `mplus` ecore2clafer args',
  file                = file args}

-- default values for arguments (the lowest priority)
setDefArgs args = args {
  mode                = mode args                `mplus` Just Alloy,
  console_output      = console_output args      `mplus` Just (null $ file args),
  flatten_inheritance = flatten_inheritance args `mplus` Just def,
  timeout_analysis    = timeout_analysis args    `mplus` Just def,
  no_layout           = no_layout args           `mplus` Just def,
  new_layout          = new_layout args          `mplus` Just def,
  check_duplicates    = check_duplicates args    `mplus` Just def,
  skip_resolver       = skip_resolver args       `mplus` Just def,
  keep_unused         = keep_unused args         `mplus` Just def,
  no_stats            = no_stats args            `mplus` Just def,
  schema              = schema args              `mplus` Just def,
  validate            = validate args            `mplus` Just def,
  noalloyruncommand   = noalloyruncommand args   `mplus` Just def,
  tooldir             = tooldir args             `mplus` Just "tools/",
  alloy_mapping       = alloy_mapping args       `mplus` Just def,
  self_contained      = self_contained args      `mplus` Just def,
  add_graph           = add_graph args           `mplus` Just def,
  show_references     = show_references args     `mplus` Just def,
  add_comments        = add_comments args        `mplus` Just def,
  ecore2clafer        = ecore2clafer args        `mplus` Just def}


emptyClaferArgs = ClaferArgs Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing ""

defaultClaferArgs = setDefArgs emptyClaferArgs
