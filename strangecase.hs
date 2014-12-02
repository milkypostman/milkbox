-- file:strangecase.hs
import Data.Char(toUpper)
import Data.List.Split(splitOn)

-- Split the array of strings into two types. The front matter and the
-- entry itself.
getEntry' :: [String] -> (String, String)
getEntry' [] = ("", "")
getEntry' (x:xs) | ("---" == x) = ("", unlines $ dropWhile ((==) "") xs)
                 | otherwise = cons x $ getEntry' xs
  where cons z (y, ys) = (z ++ y, ys)

getEntry :: [String] -> (String, String)
getEntry (x:xs) | ("---" == x) = getEntry' xs
                    | otherwise = getEntry xs

main =
  putStrLn $ show $ getEntry [
    "part before this",
    "---",
    "this is a test",
    "---",
    "",
    "now I am typing some stuff",
    "end"
    ]
