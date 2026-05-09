wget -e robots=off -mkEpnp https://example.com

-e robots=off = 關閉 robots 協定，會忽略 robots.txt、HTML 裡的 nofollow 標籤、meta robots 標籤
-m = --mirror 鏡像備份網站（無限深度）
-k = --convert-links 把連結改成本地相對路徑
-E = --adjust-extension 自動加上副檔名
-p = --page-requisites 沒有這個參數的話，只會下載 HTML 檔案
-np = 不要往上層目錄爬

source: [wiwi.blog](https://www.wiwi.blog/docs/terminal/backup-website-wget)
