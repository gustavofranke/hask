import qualified Control.Monad.State.Strict as State
import           Data.Text (pack)
import           Data.Time (UTCTime, defaultTimeLocale, parseTimeOrError)
import           Lib.Core.Account (Account (..))
import           Lib.Core.Id (Id (Id, unId))
import           Lib.Repository.AccountRepo (AccountRepo (..))
import qualified Relude.Unsafe as Unsafe
import           Test.Hspec (describe, hspec, it)
import           Test.Hspec.Expectations (shouldBe)

timeFormat :: String
timeFormat = "%H:%M:%S"
understandTime :: String -> UTCTime
understandTime = parseTimeOrError True defaultTimeLocale timeFormat

a1 :: Account
a1 = Account { accountNo = "a-001"
             , accountName = "a-name-1"
             , openDate = understandTime "10:30:20"
             , closeDate = Nothing
             , userId = Id (pack "u-001")
             }
a2 :: Account
a2 = Account { accountNo = "a-002"
             , accountName = "a-name-2"
             , openDate = understandTime "10:30:20"
             , closeDate = Nothing
             , userId = Id (pack "u-002")
             }

accounts :: [Account]
accounts = [a1, a2]

main :: IO ()
main = hspec $ do
  describe "getAccountByUserId" $ do
    it "works" $ do
      let res = State.evalState (getAccountByUserId "u-001") accounts
      res `shouldBe` a1
