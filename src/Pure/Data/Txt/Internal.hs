{-# LANGUAGE CPP, PatternSynonyms, ViewPatterns, TypeSynonymInstances, OverloadedStrings #-}
module Pure.Data.Txt.Internal (module Pure.Data.Txt.Internal, module Export) where

#ifdef __GHCJS__
import Pure.Data.Txt.Internal.GHCJS as Export
#else
import Pure.Data.Txt.Internal.GHC as Export
#endif

-- from bytestring
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy.Char8 as BSLC

-- from text
import qualified Data.Text.Encoding as T
import qualified Data.Text.Lazy.Encoding as TL

-- from template-haskell
-- Note that some cross-compilation targets don't support template haskell
#ifdef USE_TEMPLATE_HASKELL
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
#endif

{-
It is important to note that ToTxt/FromTxt can throw exceptions!

If you don't know where a value came from, be careful!

In general, for pure, this isn't much of an issue as the values we deal with
were either generated locally or have been produced over a websocket and thus
have already been safely utf-8 decoded.

These instances of FromTxt (Txt -> a) should be safe:

* String
* Text
* Lazy Text
* ByteString
* Lazy ByteString

These instances of ToTxt (a -> Txt) are unsafe:

* ByteString
* Lazy ByteString

-}

pattern Translated :: (ToTxt t, FromTxt t, ToTxt f, FromTxt f) => f -> t
pattern Translated t <- (fromTxt . toTxt -> t) where
  Translated f = fromTxt $ toTxt f

instance ToTxt Bool where
  toTxt True  = "true"
  toTxt False = "false"

#ifdef USE_TEMPLATE_HASKELL
instance Lift Txt where
  lift (unpack -> str) = [| pack str |]
#endif

instance ToTxt a => ToTxt (Maybe a) where
  toTxt (Just a) = toTxt a
  toTxt Nothing = mempty

instance FromTxt a => FromTxt (Maybe a) where
  fromTxt x = if x == mempty then Nothing else Just (fromTxt x)

instance ToTxt () where
  toTxt _ = "()"

instance ToTxt BSLC.ByteString where
  toTxt = toTxt . TL.decodeUtf8

instance ToTxt BC.ByteString where
  toTxt = toTxt . T.decodeUtf8

instance ToTxt Txt where
  toTxt = id

