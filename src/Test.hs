{-# LANGUAGE PackageImports #-}
module Test where
import "this" Imports

main = do
    if all (== True) tests
    then print "all good"
    else print "error"

tests = 
  [ Nothing ? 3 == 3
  , Just "d" ? "fre" == "d"
  ]