(ns emojillionaire.components.how-to-play-page
  (:require
    [cljs-react-material-ui.reagent :as ui]
    [emojillionaire.components.emoji :refer [emoji]]
    [emojillionaire.components.layout :refer [outer-paper row col headline]]
    [emojillionaire.utils :as u]))

(defn how-to-play-page []
  [outer-paper
   [headline "How to play" :ant] [:br]
   [:h2 "Since emojillionaire is based on blockchain technology "
    [u/new-window-link "https://ethereum.org/" "Ethereum"] ", you will need a tool to manage your money
    in ETH cryptocurrency."] [:br]
   [:h3 "There are 2 ways how to start playing emojillionaire"]
   [:ol
    [:li
     [:div "Download " [u/new-window-link "https://github.com/ethereum/mist" "Mist browser"] ". This is official
      Ethereum application. It's a complete solution for using Ethereum, but it will need to download blockchain first
       (several gigabytes). After setting up Mist, creating and funding your wallet with it, open emojillionaire
       inside Mist. To make your wallet visible to the website, click in a right top corner \"Connect\", and
       choose your wallet. Now, just pick an emoji and click to pay!"] [:br]]
    [:li
     [:div "Download Chrome extension " [u/new-window-link "https://metamask.io/" "MetaMask"] ".
     This is more lightweight solution, super easy to use! So first, you must add it to Chrome, create your new wallet
       and fund it with some ETH. After this, emojillionaire should automatically see your wallet, then
       just pick an emoji and click to pay!"]]]])
