#!/bin/bash
#やってることは、同フォルダのcalendarMap.configから変更したいテスト日付を取得すること
#当shell実行時の実日yyyymmddを取得
actualDate=$(date '+%Y%m%d')
asOfDate=$(grep ${actualDate} calendarConfig.csv| cut -d, -f2)
echo ${asOfDate}