#!/usr/bin/env bash
#やってることは、指定の基準日指定でバッチ実行シェルを順番に呼び出す

#実行ログ
#normalLog="/home/amcmsadm/ajs/log/normal_$(date '+%Y%m%d%H%M%S').log"
#errlLog="/home/amcmsadm/ajs/log/error_$(date '+%Y%m%d%H%M%S').log"
#exec 1>>$normalLog
#exec 2>>$errlLog

#エラーが発生したら実行中止
set -eu -o pipefail

#基準日取
asOfDate=$(/bin/bash getCalendar.sh)

#基準日が取れない場合＝日変不要日の場合、ここで処理を終了する。終了コードは9にする。
if test "$asOfDate" = "" ; then
 echo asOfDate=$asOfDate
 exit 9
fi

#MMMシェルの実行 実行ユーザー切り替え有（amcmsadm -> ammmsadm)
sudo -u ammmsadm /bin/bash /home/ammmsadm/ajs/mmmJob1.sh $asOfDate << EOF
ammmsadm
EOF
#MMMシェルの実行 実行ユーザー切り替え無（amcmsadmのまま）
/bin/bash /home/ammmsadm/ajs/mmmJob2.sh $asOfDate

#ALMのシェル実行
/bin/bash /home/amcmsadm/ajs/almJob1.sh $asOfDate
/bin/bash /home/amcmsadm/ajs/almJob2.sh $asOfDate?
#ALM実行後のMMMシェル実行
/bin/bash /home/ammmsadm/ajs/mmmAfterAlmJob1.sh $asOfDate
#MMM実行後のALMシェル実行
/bin/bash /home/amcmsadm/ajs/almAfterMmmJob1.sh $asOfDate

#正常終了時の終了コード0を返す
echo 0