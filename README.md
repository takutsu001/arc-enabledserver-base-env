# arc-enabledserver-base-env

## はじめに
本 Bicep は Arc enabled-Server 検証環境用 のベース環境を作成するBicepです

## 構成図
![](/images/arc-enabledserver-base-topology.png)

> [!NOTE]
> - オンプレ環境を準備するのは大変なので、Azure上に作成しています
> - AzureVM を Arc で管理しようとするとエラーとなるため、AzureVM で事前作業を実施する必要があります。本 Bicep では実施されないため手動で行う必要があります。手順は[こちら](https://learn.microsoft.com/ja-jp/azure/azure-arc/servers/plan-evaluate-on-azure-virtual-machine)を参照してください
> - AzureVM を Arc で管理する方法は、あくまでも評価とテストだけを目的としてください

> [!WARNING]
> - 本環境は Onpre のサーバーに RDP でアクセスするような構成です。NSG で RDP(3389) への接続を許可するルールを作成していますが、セキュリティリスクが高いため、あくまでも検証用途としてご利用ください（本来は Azure Bastion や Azure Firewall を利用して踏み台サーバーへアクセスさせるべきですが、費用を下げるため NSG で穴あけを行っています）

### 前提条件
ローカルPCでBicepを実行する場合は Azure CLI と Bicep CLI のインストールが必要となります。私はVS Code (Visual Studio Code) を利用してBicepファイルを作成しているのですが、結構使いやすいのでおススメです。以下リンクに VS Code、Azure CLI、Bicep CLI のインストール手順が纏まっています

https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/bicep/install

## 使い方
本リポジトリーをローカルPCにクローンし、パラメータファイル (main.prod.bicepparam) を修正してご利用ください

**main.prod.bicepparam**
![](/images/arc-bicepparam.png)

> [!IMPORTANT]
> NSGルール作成用の ***myipaddress*** の修正は必須となります。それ以外のパラメータの修正は任意で実施してください。Azureに接続するクライアントのパブリックIPアドレスが分からない場合は[こちらのサイト](https://www.cman.jp/network/support/go_access.cgi)で確認することができます

※Git を利用できる環境ではない場合はファイルをダウンロードしていただくでも問題ないと思います。その場合は、以下の構成でローカルPCにファイルを設置してください

```
main.bicep
main.prod.bicepparam
∟ modules/
　　∟ onpreEnv.bicep
```

## 実行手順 (Git bash)

#### 1. Azureへのログインと利用するサブスクリプションの指定
```
az login
az account set --subscription <利用するサブスクリプション名>
```
> [!NOTE]
> az login を実行するとWebブラウザが起動するので、WebブラウザにてAzureへのログインを行う

#### 2. ディレクトリの移動（main.bicep を設置したディレクトリへ移動）
```
cd <main.bicepを設置したディレクトリ>
```

#### 3. デプロイの実行
```
az deployment sub create --location japaneast -f main.bicep -p main.prod.bicepparam
```
> [!NOTE]
> コマンドで指定する `--location` はメタデータを格納する場所の指定で、Azure リソースのデプロイ先ではない (メタデータなのでどこでも問題ないが、特に要件がなければAzureリソースと同一の場所を指定するで問題ない) 

#### 4. Azureからのログアウト
```
az logout
```

## その他
 - 本Bicepは [ampls-base-env](https://github.com/takutsu001/ampls-base-env) をベースに作成しています
 - 本Bicepでは Onpre のサーバーのパブリックIP に対する DNS レコードの登録は削除しています