module Absclafer2alloy where

-- Haskell module generated by the BNF converter

newtype Ident = Ident String deriving (Eq,Ord,Show)
data Module =
   Module [Declaration]
  deriving (Eq,Ord,Show)

data Declaration =
   EnumDecl Ident [EnumId]
 | AbsClaferDecl GCard Ident Super Attr Elements
 | ClaferDecl Clafer
 | ConstDecl Constraint
  deriving (Eq,Ord,Show)

data Clafer =
   Clafer GCard Ident Super Attr Essential Card Elements
  deriving (Eq,Ord,Show)

data Constraint =
   Constraint Essential [LExp]
  deriving (Eq,Ord,Show)

data Elements =
   ElementsEmpty
 | Elements [Element]
  deriving (Eq,Ord,Show)

data Element =
   Subclafer Clafer
 | ClaferUse Name Essential Card Elements
 | Subconstraint Constraint
  deriving (Eq,Ord,Show)

data Essential =
   EssentialEmpty
 | Essential
  deriving (Eq,Ord,Show)

data Super =
   SuperEmpty
 | SuperColon Name
 | Super Name
  deriving (Eq,Ord,Show)

data Attr =
   AttrEmpty
 | Attr [ModId] Nav
  deriving (Eq,Ord,Show)

data GCard =
   GCardEmpty
 | GCardXor
 | GCardOr
 | GCardMux
 | GCardOpt
 | GCardInterval GNCard
  deriving (Eq,Ord,Show)

data Card =
   CardEmpty
 | CardLone
 | CardSome
 | CardAny
 | CardInterval NCard
  deriving (Eq,Ord,Show)

data GNCard =
   GNCard Integer ExInteger
  deriving (Eq,Ord,Show)

data NCard =
   NCard Integer ExInteger
  deriving (Eq,Ord,Show)

data ExInteger =
   ExIntegerAst
 | ExIntegerNum Integer
  deriving (Eq,Ord,Show)

data Nav =
   NavJoin Nav Nav
 | NavArrow Nav Nav
 | NavIdent Ident
  deriving (Eq,Ord,Show)

data Name =
   Name [ModId] Ident
  deriving (Eq,Ord,Show)

data LExp =
   EIff LExp Iff LExp
 | EImplies LExp Implies LExp
 | EImpliesElse LExp Implies LExp LExp
 | EOr LExp Or LExp
 | EXor LExp Xor LExp
 | EAnd LExp And LExp
 | ENeg Neg LExp
 | ETerm Term
  deriving (Eq,Ord,Show)

data Term =
   TermCmpExp CmpExp
 | TermSet SExp
 | TermQuantSet Quant SExp
 | TermQuantDeclExp [Decl] LExp
  deriving (Eq,Ord,Show)

data Iff =
   Iff
  deriving (Eq,Ord,Show)

data Implies =
   Implies
  deriving (Eq,Ord,Show)

data And =
   And
  deriving (Eq,Ord,Show)

data Xor =
   Xor
  deriving (Eq,Ord,Show)

data Or =
   Or
  deriving (Eq,Ord,Show)

data Neg =
   Neg
  deriving (Eq,Ord,Show)

data CmpExp =
   ELt Exp Exp
 | EGt Exp Exp
 | EREq Exp Exp
 | EEq Exp Exp
 | ELte Exp Exp
 | EGte Exp Exp
 | ENeq Exp Exp
 | ERNeq Exp Exp
 | EIn Exp Exp
 | ENin Exp Exp
  deriving (Eq,Ord,Show)

data Exp =
   ESetExp SExp
 | ENumExp AExp
 | EStrExp StrExp
  deriving (Eq,Ord,Show)

data Quant =
   QuantNo
 | QuantLone
 | QuantOne
 | QuantSome
  deriving (Eq,Ord,Show)

data ExQuant =
   ExQuantAll
 | ExQuant Quant
  deriving (Eq,Ord,Show)

data SExp =
   SExpUnion SExp SExp
 | SExpIntersection SExp SExp
 | SExpDomain SExp SExp
 | SExpRange SExp SExp
 | SExpJoin SExp SExp
 | SExpArrow SExp SExp
 | SExpIdent Ident
  deriving (Eq,Ord,Show)

data Decl =
   Decl ExQuant Disj [LocId] SExp
  deriving (Eq,Ord,Show)

data Disj =
   DisjEmpty
 | Disj
  deriving (Eq,Ord,Show)

data AExp =
   EAdd AExp AExp
 | ESub AExp AExp
 | EMul AExp AExp
 | EUmn AExp
 | ECSetExp SExp
 | EInt Integer
  deriving (Eq,Ord,Show)

data StrExp =
   EConc StrExp StrExp
 | EStr String
  deriving (Eq,Ord,Show)

data EnumId =
   EnumIdIdent Ident
  deriving (Eq,Ord,Show)

data ModId =
   ModIdIdent Ident
  deriving (Eq,Ord,Show)

data LocId =
   LocIdIdent Ident
  deriving (Eq,Ord,Show)

