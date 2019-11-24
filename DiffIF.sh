#!/bin/sh

##list.txtに記載されている値が無い行を出力する####

#IF file関連の変数
ifFileDir=/home/Campanella/test/ifFile/
ifFileTradeNoListDir=/home/Campanella/test/tmp/

#Search対象のlist
searchList=/home/Campanella/test/list.txt

#resultファイル（Search対象IFファイル名,HitしなかったTradeNo　形式で出力）
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
resultFileDir="/home/Campanella/test/result/"
resultFileName="rAesultFile_"${TIMESTAMP}

#Search対象のlist
tmpIf=/home/Campanella/test/list.txt

#結果ファイル
touch ${resultFileDir}${resultFileName}

#IFファイル毎にTradeRefType,TradeRefNoのリストを作成し、Search対象listのものがいるか検証
for ifFileList in $( ls ${ifFileDir} ); do
    #echo ${ifFileList} >> ${resultFileDir}${resultFileName}

    #IF毎のTradeRefType,TradeRefNoのリスト
    touch ${ifFileTradeNoListDir}tmp${ifFileList}${TIMESTAMP}
    
    while read ifLine #IFファイル1行毎の操作
    do
        #IFファイル1行のTradeRefType、TradeRefNo列の値を抽出
        TradeRefType=$(echo ${ifLine} | cut -d ',' -f 1)
        TradeRefNo=$(echo ${ifLine} | cut -d ',' -f 2)

        #IFファイル毎のTradeRefType,TradeRefNoリストに書き出し
        echo ${TradeRefType}${TradeRefNo} >> ${ifFileTradeNoListDir}tmp${ifFileList}${TIMESTAMP}

    done < ${ifFileDir}${ifFileList}

    while read searchLine #Search対象list1件毎にIFファイル毎のTradeRefType,TradeRefNoリストに存在するか検証
    do
        #Search対象のlist1件事に、IFファイル毎のTradeRefType,TradeRefNoのリストに存在するか確認
        grepResult=$(grep -x ${searchLine} ${ifFileTradeNoListDir}tmp${ifFileList}${TIMESTAMP} | wc -l)
            if [ ${grepResult} -eq 0 ]; then
                    #存在しない場合、対象のTradeRefType,TradeRefNoをresultファイルに書き出し
                    echo ${ifFileList}','${searchLine} >>  ${resultFileDir}${resultFileName}
            fi

    done < ${searchList}

done
