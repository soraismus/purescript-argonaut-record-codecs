{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "argonaut-codecs"
    , "console"
    , "control"
    , "effect"
    , "either"
    , "foreign-object"
    , "generics-rep"
    , "maybe"
    , "proxy"
    , "psci-support"
    , "record"
    , "test-unit"
    , "type-equality"
    , "typelevel-prelude"
    , "unsafe-coerce"
    ]
, packages =
    ./packages.dhall
}
