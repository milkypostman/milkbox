-- file:strangecase.hs
import Data.Char(toUpper)
import Data.List.Split(splitOn)

addToFirst :: String -> (String, String) -> (String, String)
addToFirst x (y, ys) = (x ++ y, ys)

-- Split the array of strings into two types. The front matter and the
-- entry itself.
getEntry' :: [String] -> (String, String)
getEntry' [] = ("", "")
getEntry' (x:xs) | ("---" == x) = ("", unlines $ dropWhile ((==) "") xs)
                 | otherwise = addToFirst x $ getEntry' xs

getEntry :: [String] -> (String, String)
getEntry (x:xs) | ("---" == x) = getEntry' xs
                | otherwise = getEntry xs

main = putStr $ show $ getEntry $ splitOn "\n" txt
  where txt = "part before this\n---\nthis is a test\n---\n\nnow I am typing some stuff\nend"
