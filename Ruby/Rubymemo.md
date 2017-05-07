# Ruby Goldメモ

Ruby Gold合格に向け，Rubyの文法を学習する.
学習の記憶定着化のため,疑問点や内容をまとめたメモを作成する.また,学習した知識を用いてRubyプログラムを作成する.

- 参考資料
  - Ruby技術者認定試験合格教本
  - メタプログラミングRuby
  - Rubyのインターフェース
- 作りたいプログラム
  - 代数系プログラム(単因子論,グレブナー基底,ガロア理論)
  - Mathtodon改良(画像プログライン,Bot作成等)
  - 機械学習ライブラリ

## 更新履歴
| 日付     | 概要    |
| :------------- | :------------- |
| 20170503    | ブロック(3-10)についてまとめる    |
| 20170504    | 問題1-11の解答/解説を作成 |
| 20170505    | 継承(4-1,4-2)の概略を記述  |
| 20170506    | ディレクトリ(5-8)を記述      |

# Ruby基本
1-4章ではRubyの基本的な文法を記述する.
そのため、定義も含め使いかを記述する.
5-6章ではライブラリについて記述するので,インターフェースベースで記述する.

## 3-10 ブロックとProc
### 3-10-1 ブロックの基本
ブロックの定義は後にし、使い方について説明する.
ブロックはメソッド呼び出し後に記述し,yieldを使用することでブロックの内部で記述した処理を呼び出す.
ブロックは新たにスコープを作成する.(スコープに作成するという表現は妥当?)
スコープとは,変数(等?)が参照できる範囲のこと.

__例__:
```ruby
def func x
  x + yield
end
p func(1){ 2 }
```
⇒3  
ブロック外で定義された変数をブロック内で参照、更新できる.ブロック内で定義された変数はブロック外で参照できない.

__例__:
```ruby
def func x
  x + yield
end
func(1) do
  x =2
end
p x
```
⇒undefined local variable or method for main:Object(NameError).



### 3-10-2 ブロックのフォーマットと判定
{} あるいは,do end
で定める.その範囲内がブロックである.
ブロックはメソッドの呼び出し直後につなげる.
引数を与えることができ,引数は||でくくって与える.
ブロックを実行するには,yieldを記述すればよい.ブロックには復帰値が存在し、blockの最終行の評価結果が返される.
nextでブロックを抜けた場合はnilを返す.
またyieldを呼び出すメソッドにblockが与えられていない場合はLocalJumpErrorが発生する.
メソッド内でブロックが実施された場合とそうでない場合を分ける時はblock_given?をもって判定すればよい.

### 3-10-3 Proc
Prcoオブジェクトではブロックを予め定義できる.
状況に応じて遅延評価したい時に有効?
初期値などに依存しない処理を繰り返したい時に有効なのだろうか.
Rubyのメソッドはその時点での値を見るから?
ブロックを実際に実行するにはProcobject.call(引数)を実行すればよい.
Procオブジェクト a をブロックに変換するには&aにすればよい.
逆にブロックをProcオブジェクトに変換する場合も&aで可能.(こっちはyieldを無理やりProc.callにしているだけな気がするのだが実用性はあるのか?)

### 3-10-4 lambda
lambdaメソッド
Procと似ているが挙動が異なる.
Procオブジェクトは内部でreturnすると,そのScopeを終了させる.
つまりメソッド内でPrco.callを実施した場合そのProc オブジェクトにretrunが記されていたらメソッドごと終了する.それはブロックでも同じ.ただし、lambdaではそうならない.
また,引数の数が異なる場合にProcでは無視されるだけだが、
LambdaではArgumentErrorが発生する.

lambdaは以下の書き方がある.
```ruby
(1) lmd = lambda{ |x| p x}
(2) lmd = ->(x){ p x}
```

### 3-10-5 ブロックを受けるメソッド
each等がある.例を記述する.

```ruby
[1,2,3].each do |value|
  p value
end
```

```ruby
[3,4,5].each_with_index do |value, index|
  p value + index
end
```

```ruby
{:a => 1,:b => 2}.each do |key, value|
  p "#{key}:#{value}"
end
```
Hashにはeach_key,each_valueメソッドも存在する.
eachはRange objectにも使える.

uptoメソッド
```ruby
2.upto(4) do |i|
  p i
end
```
timesメソッドもある.
```ruby
4.times do |i|
  p i
end
```

となる.


## 4-1 クラス定義
### 4-1-1 clsss式
```ruby
class <クラス名>

end
```
でclassを定義できる.クラス名は、大文字で始める.(定数である必要がある)
クラスは定数なので、変数に代入できる.ただし、クラス内に定義したメソッドはインスタンスに対するメソッドなので、変数に代入しても使えない.
```ruby
class ABC          
  def hello        
    p "hello world"
  end              
end                
f=ABC              
#f.hello  ⇒undefined methodになる.        
a=f.new            
a.hello
```
また、クラス定義の内部が評価されるのはclass式が初めて読み込まれたときなので,
```ruby
p 1
class Hoge
  p 2
  def four
    p 4
  end
end
p 3
Hoge.new.four
```
実行結果:1,2,3,4となる.

### 4-1-2 インスタンスメソッドと初期化メソッド
インスタンスメソッドはメソッドのこと.
初期化はinitializeメソッドのこと.
initializeメソッドはclassを初期化(new)したときに呼ばれる.
```ruby
class Hoge
  def initialize(a)
    p "init"
    p a
  end
end
first =Hoge.new(1)
second = Hoge.new(2)
first.initialize(3)
```
また,initializeはPrivateメソッド扱いのため、クラス外からアクセスできない.
(インスタンスメソッドからinitializeにアクセス可能.)

### 4-1-3 クラス継承
```ruby
class A < B
end
```
で継承できる.
superclassはA.superclassで取得できる.

### 4-1-4 super
class Aのmethod内で同名のsuperclassのメソッドを呼ぶ時は,superを実施すればよい.

## 4-2 インスタンスメソッド
### 4-2-1 クラスオブジェクト

### 4-2-2 継承したクラスオブジェクト

### 4-2-3 メソッドの探索経路

### 4-2-4 継承チェーンとmethod_missing

### 4-2-5 オープンクラス
classは定義済みのものをもう一度定義できる.
新しく定義された段階でメソッドは再度評価される.

## 4-3 Mix-in


## 5-8 Dirクラス,IOクラス,FIleクラス
メソッドのインターフェースを記述するフォーマットを記載する
#### Format
__メソッド名(引数含む)__
`メソッド名`
ex.`entries(path, encoding: enc) -> [String]`
__インターフェース__
| 項目 | 説明     |
| :------------- | :------------- |
| _path_       | ◎◎     |
| _ret_ | String型の配列 |

__概要__:

__入力__:

__コード例__:

### 5-8-1 Dirクラス



| 種類   | メソッド名      $\quad \quad \quad $  |
| :------------- | :------------- |
| 特異メソッド     |  [[]](#kakko)  <br> [glob](#glob) <br> [chdir](#chdir) <br> [chroot](#chroot) <br> [delete](#delete) <br> [rmdir](#rmdir) <br> [unlink](#unlink) <br> [entries](#entries) <br> [exist?](#exist?) <br> [exists?](#exists?) <br> [foreach](#foreach) <br> [getwd](#getwd) <br> [pwd](#pwd) <br> [home](#home) <br> [mkdir](#mkdir) <br> [new](#new) <br> [open](#open) <br> |
| インスタンスメソッド | [close](#close) <br> [each](#each) <br> [fileno](#fileno) <br> [inspect](#inspect) <br> [path](#path) <br> [to_path](#to_path) <br> [pos](#pos) <br> [tell](#tell) <br> [pos=](#pos=) <br> [seek](#seek) <br> [read](#read) <br> [rewind](#rewind)  <br>  |

__特異メソッド__
#### <a name="kakko">  []
__概要__  
カレントディレクトリ(Dir.pwd)内に対し,ファイル名で指定した条件に検索しマッチしたファイルを返却する.

__引数__

__コード例__
```ruby
Dir["abc","def"]
```

メソッドだが.をつけない.
該当条件は,で区切った条件のいずれかにマッチしたもの
復帰値は配列.配列の順序は不明.(ルールはあるだろうか、特に記述なし)

#### <a name="glob"> glob
上の[]と同じ方法

__引数__  
_pattern_:  
文字列で指定する. patternを "\0" で区切って 1度に複数のパターンを指定することも可能。区切りは"\0" のみ指定可能。配列でも複数の指定可能。  
_flags_:  
File.fnmatchに指定できるフラグと同様のフラグを指定可能。
このフラグを指定することでマッチの挙動を変更可能。
```ruby
  Dir.glob("*")                      #=>["bar","foo"]
  Dir.glob("*", File::FNM_DOTMATCH)  #=> [".", "..", "bar", "foo"]
```

ワイルドカードには以下のものがあります。これらはバックスラッシュによりエスケープすることができます。ダブルクォートの文字列中では 2 重にエスケープする必要があることに注意してください。ワイルドカードはデフォルトではファイル名の先頭の "." にマッチしません。

| __文字列__ | __概要__     |
| :------------- | :------------- |
| \*  | 空文字列を含む任意の文字列と一致 |
| ? | 任意の一文字と一致 |
| [ ] | 鈎括弧内のいずれかの文字と一致 -でつながれた文字は範囲を表す。 <br> 鈎括弧の中の最初の文字が^である時には含まれない文字と一致します。^の代わりに !も利用可能. |
| { } | コンマで区切られた文字列の組合せに展開します。例えば、 foo{a,b,c} は fooa, foob, fooc に展開され、それぞれに対してマッチ判定する。 括弧は入れ子にすることができます。例えば、 {foo,bar{foo,bar}} は foo, barfoo, barbar のそれぞれにマッチします。 |
| \*\*/ |  ワイルドカード \*/ の0回以上の繰り返しを意味し、 ディレクトリを再帰的にたどってマッチを行います。 例えば, foo/\*\*/bar は foo/bar, foo/\*/bar, foo/\*/\*/bar ... (以下無限に続く)に対してそれぞれ マッチ判定を行います。

#### <a name="chdir"> chdir
__インターフェース__:

| 項目 |  説明 |
| :------------- | :------------- |
| __引数__ | ディレクトリパスの文字列. <br> 省略された場合は 環境変数 __HOME__ または __LOGDIR__      
|__復帰値__ |  <ul> <li>ブロック無しの場合 <br> 0(成功時のみ).失敗した時はException </li> <li> ブロック有の場合  <br> ブロックの復帰値  |

カレントディレクトリを pathに変更する。
path を省略した場合、環境変数 HOME または LOGDIR が設定されていればそのディレクトリに移動します。カレントディレクトリの変更に成功すれば 0 を返します。
ブロックが指定された場合、ブロック内のみカレントディレクトリを指定したディレクトリと扱われる.復帰値はブロックの実行結果.

```ruby
Dir.chdir("/var/spool/mail")
p Dir.pwd                    #=> "/var/spool/mail"
Dir.chdir("/tmp") do
  p Dir.pwd                  #=> "/tmp"
end
p Dir.pwd                    #=> "/var/spool/mail"
```

#### <a name="chroot"> chroot
__インターフェース__
| 項目 | 説明     |
| :------------- | :------------- |
| __引数__ | ディレクトリパスの文字列.  
| __復帰値__ | 0(成功した場合)、失敗したときは該当するエラーが返る?      |

__概要__:  
ルートディレクトリをpathに変更する。
スーパーユーザだけがルートディレクトリを変更できます。 ルートディレクトリの変更に成功すれば0を返します。各プラットフォームのマニュアルのchrootの項も参照して下さい。



__コード例__:
```ruby
p Dir.glob("*")   #=> ["file1", "file2]
Dir.chroot("./")
p Dir.glob("/*")  #=> ["/file1", "/file2]
```

#### <a name="delete"> delete
| 項目 | 説明     |
| :------------- | :------------- |
| __引数__ | ディレクトリパスの文字列.  
| __復帰値__ | 0(成功した場合)、失敗した場合は該当する例外を返す.      |

__概要__:  
ディレクトリを削除します。ディレクトリは空でなければいけません。ディレクトリの削除に成功すれば0を返します。


__コード例__:
```ruby
Dir.delete("/tmp/hoge-jbrYBh.tmp")
```

#### <a name="rmdir"> rmdir
[delete](#delete)と同じ
#### <a name="unlink"> unlink
[delete](#delete)と同じ.
#### <a name="entries"> entries

`entries(path, encoding: enc) -> [String]`
| 項目 | 説明     |
| :------------- | :------------- |
| _path_ | ディレクトリパスの文字列.  |
| _enc_ | ディレクトリのエンコーディングを文字列かEncoding オブジェクトで指定。省略した場合は ファイルシステムのエンコーディング |
| __復帰値__ | ディレクトリ _path_ に含まれるファイルエントリ名の配列.失敗した場合は例外を返す. |

ディレクトリ path に含まれるファイルエントリ名の 配列を返します。

#### <a name="exist?"> exist?
`exist?(file_name) -> bool`

__インターフェース__
| 項目 | 説明     |
| :------------- | :------------- |
| __file_name__      | ファイルパスの文字列(相対パスのみ?)       |
| __復帰値__ |0(成功した場合)|

__概要__  
*file_name* で与えられたディレクトリが存在する場合に真を返します。 そうでない場合は、偽を返します。

```ruby
Dir.exist?(".")      # => true
Dir.exists?(".")     # => true
File.directory?(".") # => true
```
#### <a name="exists?"> exists?
このメソッドは deprecated(非推奨)です。Dir.exist? を使用してください。
#### <a name="foreach"> foreach
```ruby
foreach(path) {|file| ...} -> nil
foreach(path, encoding: enc) {|file| ...} -> nil
foreach(path) -> Enumerator
foreach(path, encoding: enc) -> Enumerator
```
__インターフェース__
| 項目   | 概要    |
| :------------- | :------------- |
| _path_       | ディレクトリのパスを表す文字列    |
| _encoding_ | ディレクトリのエンコーディングを文字列か Encoding オブジェクトで指定します。省略した場合は ファイルシステムのエンコーディングと同じになります。 |
|__復帰値__ | ブロックが与えられた場合はnil <br> ブロックが与えられなかった場合はEnueratorオブジェクト |


__例__:
```ruby
Dir.foreach('.'){|f|
  p f
}
#=>
"."
".."
"bar"
"foo"
```

#### <a name="getwd"> getwd
`getwd -> String`

__インターフェース__
| 項目 | 概要     |
| :------------- | :------------- |
| 復帰値       | カレントディレクトリのフルパスの文字列       |

__概要__  
カレントディレクトリのフルパスを文字列で返します

__例__:

```ruby
Dir.chdir("/tmp")   #=> 0
Dir.getwd  #=> "/tmp"
```

#### <a name="pwd"> pwd
[getwd](#getwd)と同じ

#### <a name="home"> home
`home -> String | nil`
`home(user) -> String | nil`

__概要__
現在のユーザまたは指定されたユーザのホームディレクトリを返します。

Dir.home や Dir.home("root") は File.expand_path("~") や File.expand_path("~root") と ほぼ同じです。

#### <a name="mkdir"> mkdir
#### <a name="new"> new
#### <a name="open"> open




__インスタンスメソッド__



#### <a name="close"> close
#### <a name="each"> each
#### <a name="fileno"> fileno
#### <a name="inspect"> inspect
#### <a name="path"> path
#### <a name="to_path"> to_path
#### <a name="pos"> pos
#### <a name="tell"> tell
#### <a name="pos="> pos=
#### <a name="seek"> seek
#### <a name="read"> read
#### <a name="rewind"> rewind


## 6-2 テキスト
### 6-2-1 StringIO
文字列をIOクラスと同じインターフェースで扱うクラス.
継承関係は右のようになっている.`StringIO < Data < Object`

## 6-9 コマンドライン
### 6-9-1 optparse
サンプルソース
```ruby
require "optparse"

opt = OptionParser.new
options={}
opt.on("-o","--output","output file"){|v| options["output"] = v}
opt.on("-i","--input","input file"){|v| options["input"] = v}

opt.parse!(ARGV)

p options
p ARGV
```
option登録の基本的な方法は以下.

1. onメソッドで登録するoptionを登録.
1. parse(!)メソッドで引数からoptionを登録する.

#### <a name="on"> on
以下の3通りがある.
- `on(short, desc = "") {|v| ... } -> self`
- `on(long, desc = "") {|v| ... } -> self`
- `on(short, long, desc = "") {|v| ... } -> self`

shortは"-"と"半角英数字1文字"のみ有効.
引数として,2文字以上の文字列を指定した場合,2文字目以降は別のoption扱いとなる.全角文字はエラーとなる.
longは"--"と半角英数字n文字(数字はOK.全角はエラーになる)
メソッド内でshot X,long Xと書くと(Xは任意の文字列),ブロック変数に次に指定したオプションの文字列が格納される。
そうでない場合(short,longのみ)は初期値Flaseで指定したオプションが存在した場合はTrueが返ってくる.
ARGVにはparse!で、評価されていない変数のみ。

それ以外のメソッドは放置.


## ライブラリ

## 問題集
### 基礎力確認問題
__問題1__. ruby -lオプションの説明として正しいものを全て選びなさい.

1. 引数で指定したディレクトリを$LOAD_PATH変数に追加する.
1. 引数で指定したファイルを読み込む.
1. 引数で指定したディレクトリを環境変数RUBYLIBに追加する.
1. 引数で指定したディレクトリはrequireやloadメソッドが呼ばれた時に検索される.

__解説__
$LOAD_PATH変数に追加される.
$LOAD_PATHの値はRubyのメソッド探索対象のディレクトリとなるので,1.4が正しい.

__参考__
1. $LOAD_PATHに存在しないディレクトリorファイルパスが指定された場合はどうなるのか?  
⇒追加して実験したが,特にエラーにはならない.探索時にエラーになる?
1. 環境変数とは?OSの変数.RUBYLIBもOSの変数だが,RUBYに影響のあるOSの変数を記す

| __変数名__     | __値__     |
| :------------- | :------------- |
| RUBYOPT      | Rubyインタプリタにデフォルトで渡すオプションを指定します。指定できないオプションを指定した場合、例外が発生します。   |
| RUBYPATH |-S オプション指定時に、環境変数 PATH による Ruby スクリプトの探索に加えて、この環境変数で指定したディレクトリも 探索対象になります。(PATH の値よりも優先します)。 起動オプションの詳細に関してはRubyの起動 を参照してください。|
| RUBYLIB | Rubyライブラリの探索パス$:のデフォル ト値の前にこの環境変数の値を付け足します。 |
| RUBYSHELL | この環境変数は mswin32版、mingw32版のrubyでのみ有効です。Kernel.#system でコマンドを実行するときに使用するシェル を指定します。この環境変数が省略されていればCOMSPECの値を 使用します。|
| PATH | Kernel.#systemなどでコマンドを実行するときに検索するパスです。 設定されていないとき(nilのとき)は "/usr/local/bin:/usr/ucb:/usr/bin:/bin:." で検索されます。 |

環境変数「COMSPEC」はコマンドインタープリター(Command.comやCmd.exe)のパスを持つ環境変数で、主にシステムによって使用されます

__問題2__ 以下のコードの結果を表示せよ.
```ruby
x, *y = *[0,1,2]
p x,y
```

__解説__ `*y`は残りの変数を設定する.`*[0,1,2]`は配列を展開するので、0,1,2という値の変数が入っている.そのため,
0 改行1,2が出力される.

__参考__
```ruby
print 'hello (print)' # 改行なしで出力
puts 'hello(put)' # 改行ありで出力
p 'hello(p)' # デバッグ用出力（データ形式がわかる）
```

__問題3__ Xに記述すると,以下の実行結果にならないコードをすべて選びなさい

1. 4 / 5
1. 4.0 / 5
1. 4/5r
1. 4 / 5.0

__解説__ 1.は整数型となるため0となる.3は有理数型であり,`to_f`すれば0.8になる.

__問題4__
以下のコードを実行するとどうなりますか?

```ruby
class Err1 < StandardError; end
class Err2 < Err1; end
begin
raise Err2
rescue => e
  puts "StandardError"
rescue Err2 => ex
  puts ex.class
end
```

__解説__:StandardErrorと表示される

`rescue *例外クラス* => *変数名*`
で指定した例外クラスが起きた場合にその例外を変数名に代入する.
ただし、例外クラスと変数名はなくてもよい.例外クラスの指定がない場合はすべての例外クラスに対して,実行される.


__問題5__: 以下のコードを実行するとどうなりますか.
```ruby
class C
  VAR=0
  def VAR = v
    VAR=v
  end
  def VAR
    VAR
  end
end
c = C.new
c.VAR=3
puts c.VAR
```

__解説__:
メソッド内での定数の代入はエラー(dynamic constant assignment)となる(04行目).
ただし、VARをvarに変換して実行するとstack level too deep (SystemStackError)となる。何が悪いのか今の段階では不明のため、原因分析必要.


__問題6__:以下のコードの中で文法として正しいものをすべて選びなさい

1. 1.upto(5) do |x| puts x end
1. 1.upto 5 do |x| puts end
1. 1.upto 5 { |x| puts x }
1. 1.upto(5) { |x| puts }

__解説__: {}ブロックを実施するメソッドの引数は()でくくる必要がある.よって1,2,4.


__問題7__: __X__ に記述する適切なコードを全て選びなさい.

__X__

tag(:p) { "Hello, Wolrd."}

1. def tag(name)  
  puts "<#{name}>#{yield}</#{name}>"  
end
1. def tag(name)  
  puts "<#{name}>#{yield.call}</#{name}>"  
end
1. def tag(name, &block)  
  puts "<#{name}>#{block}</#{name}>"  
end
1. def tag(name, &block)  
  puts "<#{name}>#{block.call}</#{name}>"  
end

__解説__: blockはyieldで実行し,Procオブジェクトはcallメソッドで実行されるので,1,3が正解.

__問題8__: 以下の実行結果になるように __X__ に記述する適切なコードを選びなさない.

```ruby
def hoge(*args)
  p __X__
end
hoge [1,2,3]
```
実行結果 [1,2,3]

__解説__:__X__ には`*args`をいれる.
メソッドの引数`*args`は可変長の引数を配列に格納する.
今,引数は配列一つなので,
args[0]=[1,2,3]となっている.そのため、args[0] or配列を展開して表示する*が必要.


__問題9__: 以下の実行結果になるように__X__に記述する適切なコードを選びなさい

```ruby
def hoge __X__
  puts "#{x},#{y},#{params[:z]}"
end
hoge x: 1,z: 3
```
実行結果 1,2,3

1. `(x:, y: 2,params: *)`
1. `(x:, y: 2, *params)`
1. `(x:, y: 2, *params)`
1. `(x:, y: 2, paramas: **)`

__解説__:

Rubyのメソッドには様な座な呼び出し方法がある.
1. 普通の引数  
説明略.
1. キーワード引数(正式名称?)  
Hashを使った引数宣言ができる.実行時にkeyを宣言しないとエラーとなる.
1. 可変長引数  
`*`をつければ引数を複数個設定できる。これを可変長引数という。
引数は配列として受け取られる。
1. オプション引数
`**`を２つつけるとオプション引数になる。オプション引数はHashとして受け取られる。

3つめの引数はHashなので、オプション変数を使えばよい。

__参考__:
Rubyでは文字列展開(""でくくられたStringオブジェクト)

__問題10__:以下の実行結果になるように,`__X__`に記述する適切なコードを選びなさい.

```ruby
hi = __X__
p hi.call("World")
```
実行結果:"Hello, World"

1. `->{|x| puts "Hello, #{x}."}`
1. `->{(x) puts "Hello, #{x}."}`
1. `->(x){ puts "Hello, #{x}."}`
1. `\(x) -> { puts "Hello, #{x}."}`

__解説__:lambda式の文法として正しいのは,`->(x){ puts "Hello, #{x}."}`.ただし,最後に改行が追加されるため、どれも正解ではない。

__問題11__:以下の実行結果になるように`__X__`,`__Y__`に記述する適切なコードを選びなさい.

```ruby
a, b = __X__ do
  for x in 1..10
    for y in 1..10
      __Y__ if x + y = 10
    end
  end
end
puts a,b
```
実行結果
```ruby
1
9
```

__解説__
catch throwによる大域脱出では,
```ruby
catch "label"
throw "label" a
```
と実施し,throwの箇所からcatchの場所まで移動し、復帰値はaになる.
よって
catch :exit
throw :exit [x,y]
を選べばよい.

__問題12__
以下の実行結果になるように,`__X__`に記述する適切なコードを選びなさい.
```ruby
class Super
  def greet
    "Hello"
  end
end
class Sub < Super
  def greet
    __X__ + "World."
  end
end
puts Sub.new.greet
```
実行結果 Hello World.

1. super
1. overide
1. greet
1. self

__解説__:
継承先のメソッドを実行するには,superを選択すればよい.



__問題1__:
以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。

```ruby
 class Foo
   def bar(obj=nil)
    \__(1)\__
   end
   private
   def foo
     puts "foo"
   end
 end
 Foo.new.bar(Foo.new)

 [実行結果]
  foo
```

 1. foo
 2. Foo.foo
 3. self.foo
 4. obj.foo


__解説__  
privateメソッド(private以降で定義されたメソッド)はそのクラス，またはサブクラス内でのみ使用できる．また，そのメソッドを使用する時はレシーバを指定しない.
(指定するとエラーとなる)
よって1

問2．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 class Foo
   def foo
    __(1)__.bar
  end
  def bar
    puts "bar"
   end
 end
 Foo.new.foo

 [実行結果]
  bar
```
__解説__  
クラス内で定義したメソッドは，そのクラスのインスタンス内で利用可能．
インスタンスメソッド内で「self」というキーワードを使用すれば，メソッドを呼びだしておいたオブジェクト自身を参照することができる．
よって3.

問3．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 class Hello
   def greet
     "Hello "
   end
 end
 class World < Hello
   def greet
     __(1)__ + "World"
   end
 end
 puts World.new.greet


[実行結果]
 Hello World
```
__解説__  
親クラスの同名のメソッドを子クラスから呼び出す場合は「super」というキーワードを使用します。

問4．以下のコードを実行した結果を選択してください。

```ruby
a,  *b = *[1, 2, 3]
 p a
 p b
```
__解説__  
以下のように変数に値を代入することができます。
a, b = 1, 2
p a #=> 1
p b #=> 2
また、配列の頭に「\*」を付けると要素を展開することができます。
代入式の左辺の変数の先頭に「\*」を指定すると複数の要素を配列に集約して受け取ることができます。

問5． 以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください
```ruby
[コード]
 module M
   CONST = "HELLO"
 end
 puts __(1)__


[実行結果]
 HELLO
```

1. ::M::CONST
2. CONST
3. M
4. M.CONST
__解説__  
定数にアクセスする場合「::」という記号を使用します。
モジュールによって定数の名前空間が分かれておりますので、「モジュール::定数」の形式でアクセスします。
また、モジュールやクラスなどの定義の一番外側の領域をトップレベルと呼びます。
トップレベルより定数にアクセスする場合は「::モジュール::定数」という形式でアクセスすることができます。
よって1

問6．以下のコードを実行した結果を選択してください。

```ruby
class Error1 < StandardError; end
class Error2 < Error1; end
begin
 raise Error2
rescue Error1 => ex
 puts ex.class
end
```

1. Error1
2. Error2
3. StandardError
4. 何も出力されない
__解説__  
rescue節で捕捉できる例外は、指定した例外クラスと、そのクラスのサブクラスです。
この場合、捕捉する例外としてError1を指定していますが、Error1のサブクラスとして定義されたError2の例外がraiseメソッドで発生されているため、Error2の例外を捕捉することができます。よって2


問7．例外処理の構文の説明として正しいものを選択してください。
1. 例外が発生する可能性のある処理を「try ～ end」で囲み 例外が発生した場合の処理をcatch節で指定する
2. 例外が発生する可能性のある処理を「catch ～ end」で囲み 例外が発生した場合の処理をthrow節で指定する
3. 例外が発生する可能性のある処理を「begin ～ end」で囲み 例外が発生した場合の処理をrescue節で指定する
4. 例外が発生する可能性のある処理を「do ～ end」で囲み 例外が発生した場合の処理をcatch節で指定する

__解説__  
3

問8．rubyに標準で存在する定数ではないものを選択してください。

1. ENV
2. ARGV
3. ARGF
4. NULL

__解説__  
ENVは環境変数を表すオブジェクトです。
ARGVはコマンドライン引数を表すオブジェクトです。
ARGFはコマンドライン引数に指定されたファイルを表すオブジェクトです。


問9．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 class Foo
   def foo
    puts "foo"
   end
 end
 __(1)__


[実行結果]
 foo
```

__解説__  
クラス内で定義したメソッドはインスタンスメソッドになります。
インスタンスメソッドは「オブジェクト.メソッド」の形式で呼び出すことができます。
オブジェクトは「クラス.new」で生成することができますので、連続して指定すると「クラス.new.メソッド」という指定になります。よって1

問10．以下の実行結果にならないようにするために\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 class Foo
   def bar(obj=nil)
    __(1)__
  end
  protected
  def foo
    puts "foo"
  end
 end
 Foo.new.bar(Foo.new)

[実行結果]
 foo
```
__解説__  
protected以降で定義されたメソッドは、そのクラスとサブクラスのインスタンスから呼び出すことができます。
しかし、クラスをレシーバとして呼び出すことはできませんので、「Foo.foo」ではエラーになります

問11．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
class Foo
  def __(1)__
    puts "foo"
  end
end
Foo.foo()

[実行結果]
 foo
```


__解説__  
クラスメソッドはクラスをレシーバにして呼び出すことができます。
クラスメソッドは「クラス.メソッド」の形式で定義できます。
よって3.

問12．以下のコードを実行した結果を選択してください。
```ruby
class Foo
   def foo
     self
   end
 end
 class Bar < Foo
   def bar
     foo
   end
 end
 p Bar.new.bar.class
```
1. Object
2. Foo.foo
3. Bar
4. Class
__解説__  
BarクラスはFooクラスを継承しておりますので、Barクラスのインスタンスからfooメソッドを呼ぶことができます。また、fooメソッド内にある「self」は、barメソッドを呼び出したBarクラスのオブジェクトを参照します。このオブジェクトに対してclassメソッドが呼ばれますので、結果としてBarが返されます。

問13．以下の実行結果にならないようにするために\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 class Foo
   def bar
     self.foo
   end
   __(1)__
   def foo
     puts "foo"
   end
 end
 Foo.new.bar


[実行結果]
 foo
```
1. public
2. protected
3. private
4. なにも記述されない
__解説__  
privateメソッドはレシーバを指定して呼び出すことはできません。
また何も記述しない場合はpublicメソッドになりますので、なにも記述しなくてもfooメソッドを呼び出すことができます。

問14．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 puts [1,2,3].__(1)__


[実行結果]
 6
```
1. sum
2. inject(0){|sum, i| sum * i }
3. inject(0){|sum, i| sum + i }
4. add

  injectメソッドは引数で初期値を取り、レシーバの要素の先頭から順にブロック内の処理を実行し結果を求めていくメソッドです。回答のコードをeachメソッドに置き換えると以下のようになります。
```ruby
  sum = 0
  [1,2,3].each{|i| sum = sum + i }
  puts sum   #=> 6
```

問15．以下の実行結果にならないようにするために\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 puts __(1)__


[実行結果]
 2.5
```
1. 5 / 2
2. 5.0 / 2.0
3. 5.0 / 2
4. 5 / 2.0

__解説__  
整数と浮動小数点数で演算処理すると結果が浮動小数点数で返されます。
すべての数値が整数であれば整数が返されます。
回答では整数同士でのみ演算処理していますので、整数で結果が返されます。
よって1

問16．以下のコードの実行結果として正しいものを選択してください。
```ruby
[コード]
 char = { :a => "A" }.freeze
 char[:a] = "B"
 p char
```
1. "A"
2. "B"
3. エラーが発生する
4. nil

__解説__  
freezeメソッドはオブジェクトを変更不可能にするメソッドです。
ハッシュオブジェクトの値を変更しようとしている行でエラーが発生し、プログラムが終了します。
よって3

問17．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 sum = Proc.new{|x, y| x + y}
 puts __(1)__


[実行結果]
 3
```
__解説__  
Proc.newではブロックで指定した手続きを表すオブジェクトです。
手続きを呼び出す時はProcオブジェクトに対してcallメソッドを呼びます。
ブロック引数はcallメソッドの引数で渡すことができます。
よって1

問18．stringioライブラリの説明として正しいものを選択してください。

1. 文字列をIOオブジェクトのように扱うことができる
2. 文字列をファイル入出力専用で扱うことができる
3. StringIOクラスはIOクラスのサブクラスである
4. 文字列をファイルに読み書きすることができる

__解説__  
1

問19．以下のコードを実行した結果を選択してください。
```ruby
[コード]
 require 'yaml'
 dir = << EOY
 file1:
   name: file1.txt
   data: text
 EOY
 p YAML.load(dir)
```
__解説__  
yamlライブラリを使用すれば、人間が読めるテキスト形式でオブジェクトを表現することができます。
問題中のコードでは、まずハッシュのキーを指定し、さらにインデントでハッシュを指定しています。

問20．Rubyで使用可能なオプションではないものを選択してください。
1. -e
2. -t
3. -d
4. -r

__解説__  
２

__参考__
-d
--debug
デバッグモードでスクリプトを実行します。$DEBUG を true にします

-e script
コマンドラインからスクリプトを指定します。-eオ プションを付けた時には引数からスクリプトファイル名を取りません。

-e オプションを複数指定した場合、各スクリプトの間に改行を 挟んで解釈します。

以下は等価です。
```ruby
    ruby -e "5.times do |i|" -e "puts i" -e "end"

    ruby -e "5.times do |i|
      puts i
    end"
    ruby -e "5.times do |i|; puts i; end"
```

-r feature
    スクリプト実行前に feature で指定されるライブラリを Kernel.#require します。 -nオプション、-pオプションとともに使う時に特に有効です。

__問題21__
問21．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 class Person
  __(1)__ :name
 end


 person = Person.new
 person.name = "Suzuki"
 puts "Hello, " + person.name


[実行結果]
 Hello, Suzuki
```
1. attr_reader
2. attr_writer
3. attr_accessor
4. module_function

__解説__  
選択肢中のメソッドはそれぞれ以下のような機能を提供します。

attr_reader :name
nameで指定した名前のインスタンス変数「@name」に設定された値を返すメソッドを定義します。「オブジェクト.name」という形式で使用することができます。

attr_writer :name
nameで指定した名前のインスタンス変数「@name」に値を設定するメソッドを定義します。「オブジェクト.name=(引数)」という形式で使用することができます。

attr_accessor :name
上記2つのメソッドの両方を呼び出すメソッドです。インスタンス変数の参照と変更ができます。

module_functionはモジュール関数を指定するメソッドです。

問22．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 /(\d+)/ =~ "hello24world"
 puts __(1)__


[実行結果]
 24
```
__解説__  
正規表現内の括弧を記述すれば、その位置にマッチした文字列を後から参照することができます。

括弧は正規表現内で複数使用することができますが、一致した文字列は括弧が出現した順番に、特殊なローカル変数$1, $2, $3...の順番で代入されます。

問題では、括弧を1つ使用しているだけですので、正規表現に一致した文字列を取得する場合、「$1」を使用します。
よって3.


問23．以下のコマンドの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コマンドライン]
 $ ruby __(1)__ 'p 1024 * 5'


[実行結果]
 5120
```

1. -r
2. -v
3. -e
4. -s

解説
-eオプションは引数で指定した文字列を評価して、結果を出力するオプションです。
よって3.

問24．以下のコードの実行結果から\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 class Person
  def __(1)__(name)
   @name = name
  end
  def info
   puts "My name is #{@name}."
  end
 end
 Person.new("Jim").info


[実行結果]
 My name is Jim.
```
1. init
2. initialize
3. new
4. Person

  initializeメソッドは、オブジェクトの初期化処理を定義するメソッドです。
  オブジェクトが生成されるときに呼び出されます。

問25．以下のコードの実行結果として正しいものを選択してください。
```ruby
[コード]
 class Class1
  def set_value(value)
   @value = value
  end


  def get_value
   return @value
  end
 end


 obj1 = Class1.new
 obj1.set_value("value1")
 puts obj1.get_value
 obj2 = Class1.new
 puts obj2.get_value
```
1. value1nil
2. value1value1
3. nilnil
4. 実行時にエラーになる

__解説__  
@で始まる名前の変数はインスタンス変数です。
インスタンス変数はインスタンスメソッド内で使用します。
この変数はオブジェクト毎に異なるデータを保持することができます。
未初期化時に参照してもエラーにならず、nilが返されます。
(ローカル変数は未初期かで参照するとエラーとなる.)

問26．以下のコードの実行結果として正しいものを選択してください。
```ruby
[コード]
 ary = [:job1, :job2, :job3]
 ary.push(:job4)
 ary.unshift(:job5)
 ary.pop
 ary.shift
 p ary
```
1. [:job1, :job2, :job3]
2. [:job4, :job2, :job5]
3. [:job3, :job2, :job1]
4. [:job4, :job5]

__解説__  
Array#push, Array#pop, Array#unshift, Array#shiftはすべて配列の要素の追加と取り出しを行うメソッドです。
```ruby
ary = [:job1, :job2, :job3]
ary.push(:job4)
p ary     #=> [:job1, :job2, :job3, :job4]
ary.unshift(:job5)
p ary     #=> [:job5, :job1, :job2, :job3, :job4]
ary.pop
p ary     #=> [:job5, :job1, :job2, :job3]
ary.shift
p ary     #=> [:job1, :job2, :job3]
```

問27．以下のコードの実行結果として正しいものを選択してください。
```ruby
[コード]
 ary = Array.new(3, "a")
 ary[0].next!
 p ary
```
1. ["a", "a", "a"]
2. ["b", "a", "a"]
3. 実行時にエラーになる
4. ["b", "b", "b"]

解説
Array.newは配列オブジェクトを生成します。
newメソッドには2つの引数を指定することができ、1つ目には配列の要素数、2つ目には要素の初期値を指定します。この方法では.配列の要素は全て同じ参照を持つため，1つの値が参照先だけ変更されると全てが変わります．

問題文の「Array.new(3, "a")」では「["a", "a", "a"]」という配列が生成されます。
ここでの各要素は同じオブジェクトを参照することにご注意ください。

問28．以下の結果を出力するコードとして\__(1)\__に当てはまるものを選択してください。

```ruby
[コード]
 class MyNum
  attr_reader :num
  def initialize(num)
   @num = num
  end
  __(1)__
 end


 num1 = MyNum.new(30)
 num2 = MyNum.new(10)
 num3 = MyNum.new(20)
 p [num1, num2, num3].sort.map{|n| n.num }


[実行結果]
 [10, 20, 30]
```
1. include Comparable
2. include Enumerable
3. def <=>(other)
@num <=>other.num
end
4. def sort(other)
@num <=>other.num
end

__解説__
問題文のコードでは配列に対してsortメソッドを呼び出しています。
sortメソッドは、配列の要素に対して<=>演算子を使用して比較します。

数値や文字列などの既存のオブジェクトに関しては、<=>演算子が定義されているので、sortメソッドを使用することができますが、作成したクラスのオブジェクトには、<=>演算子を定義する必要があります。


問29．以下の結果を出力するコードとして\__(1)\__に当てはまるものを選択してください
```ruby
[コード]
 var1 = __(1)__
 var2 = __(1)__


 puts var1.equal?(var2)


[実行結果]
 true
```
1. "hello"
2. /hello/
3. :hello
4. ["hello"]

__解説__  
  Object#equal?はオブジェクト同士の同一性判定用のメソッドです。引数で指定したオブジェクトがレシーバ自身であればtrueを返します。
  :helloはシンボルオブジェクトを表しており、文字列が同じであれば同じオブジェクトを参照します

問30．以下のコードを実行したときの結果として正しいものを選択してください。
```ruby
[コード]
 a, b = [1, 2, 3]
 p a
 p b
```

1. 1
[2, 3]
2. [1, 2]
3
3. 1
2
4. [1, 2, 3]
nil

Rubyは多重代入をサポートしておりますので、一度に複数の変数に代入することができます。問題文のコードは下記のコードと同様です。

a = 1
b = 2

左辺の変数の数より、右辺の値の数の方が多い場合は残りの値を破棄します。
(多重代入はサポートしているだけでなく，なぜか配列を多重代入だとみなしてくれる．a,b = ary とすると，a=ary[0],b=ary[1]となる．配列が一要素しかない場合はbはnilになる.)

問31．以下の結果を出力するコードとして\__(1)\__に当てはまるものを選択してください

```ruby
[コード]
 module Mod
  __(1)__
  def func
   puts "Hello Module"
  end
 end


 Mod.func


[実行結果]
 Hello Module
```
__解説__  
「モジュール名.メソッド名」の形式で呼び出せるメソッドをモジュール関数と呼びます。モジュール関数を定義する場合、メソッドの前に「module_function」を記述します。モジュール関数はPrivateなので，includeしても他のクラスから使えない．
他のクラスからも使う場合はextend self等を使う．extendだと特異メソッドを追加するだけなので，publicな特異メソッドが手に入る．

問32．以下のコードの説明として正しいものを選択してください。なお行の先頭に記述されているのは行番号です。
```ruby
[コード]
 1: obj = Object.new
 2: def obj.hello
 3:  puts "hello"
 4: end
 5: obj.hello
 6: Object.new.hello
```
1. hello
hello
2. hello
nil
3. 2行目で文法エラーが発生する
4. 6行目でエラーが発生する
__解説__
Rubyには特定のオブジェクトにのみメソッドを定義することができます。これを特異メソッドと呼びます。特異メソッドは問題文のように「オブジェクト.メソッド名」のように定義します。
よって4.

問33．以下の結果を出力するコードとして\__(1)\__に当てはまるものを選択してください。
```ruby
[コード]
 def foo(__(1)__)
  puts arg
 end
 foo


[実行結果]
 default
```
1. arg:"default"
2. arg="default"
3. arg=>"default"
4. arg<="default"

  __解説__
  メソッド定義時に引数にデフォルト値を指定することができます。デフォルト値の指定は「引数名=デフォルト値」という形式で指定します。

問34．以下のコードの説明として正しいものを選択してください。


```ruby
[コード]
 class Foo
  def foo
   puts "foo"
  end
 end
 class Foo
  def bar
   puts "bar"
  end
 end
```

1. 2回目のFooクラスの定義でエラーが発生する
2. Fooクラスにはfooメソッドとbarメソッドが定義される
3. Fooクラスにはfooメソッドのみ定義される
4. Fooクラスにはbarメソッドのみ定義される

  解説
  Rubyにはオープンクラスという特徴があり、一度定義したクラスに後からメソッドなどを追加することができます。よって2.


  問35．モジュールの説明として正しいものを選択してください。

  1. モジュールはクラスと同様にインスタンスを生成することができる
  2. モジュールはMix-inすることで定数やメソッドなどをクラスに追加することができる
  3. モジュール定義内にクラスを定義することはできない
  4. モジュールをMix-inする場合、通常extendを使用する

__解説__  
モジュールは名前空間を提供し、includeによってクラスにMix-inして使用することができます。
コメント:インスタンスの生成の定義は何なのだろう．モジュールだって自身だけというインスタンスを生成しているようにも思えるが，newメソッドが定義できないことなのか?通常みたいな文章も非常に理解に苦しむ．

問36．メソッドのアクセス制限に関する説明として正しいものを選択してください。

1. メソッドのアクセス制限を指定しなかった場合、デフォルトでpublicになる
2. メソッドのアクセス制限を指定しなかった場合、デフォルトでprotectedになる
3. メソッドのアクセス制限を指定しなかった場合、デフォルトでprivateになる
4. メソッドのアクセス制限を省略することはできない

__解説__  
メソッド定義時にpublic、protected、privateの３つのアクセス制限を指定することができます。アクセス制限を指定しなかった場合は、デフォルトでpublicになり、メソッドが公開されます。

問37．引数の個数を固定せずに可変長にしたい場合の指定として正しい記述を選択してください。

1. \*引数
2. \$引数
3. \@引数
4. \%引数

メソッドの引数を固定せずに可変長にしたい場合、「\*引数」という形式で指定する必要があります。

問38．ブロックを受け取るための引数の指定方法として正しい記述を選択してください。

1. \*引数
2. \$引数
3. \@引数
4. \%引数
解答：２

解説
ブロックを受け取る場合、「&引数」という形式で指定する必要があります。

問39．以下のコードと同様な意味となるコードを選択してください。
```ruby
[コード]
 class Foo
  attr_accessor :foo
 end
```
1. class Foo
def foo=(foo)
@foo = foo
end
end
2. class Foo
def foo
@foo
end
end
3. class Foo
def foo
@foo
end
def foo=(foo)
@foo = foo
end
end
4. class Foo
def initialize(foo)
@foo = foo
end
end

解説
attr_accessorはアクセスメソッドを定義するメソッドです。以下のコードは、すべて同様な意味になります。

[コード1]
class Foo
　attr_accessor :foo
end


[コード2]
class Foo
　attr_reader :foo
　attr_writer :foo
end
    [コード3]
class Foo
　def foo
　　@foo
　end
　def foo=(foo)
　　@foo = foo
　end
end

問40．以下のようなfile1.rbとfile2.rbがあります。file2.rbを実行した結果として正しいものを選択してください。

```ruby
[file1.rb]
$var += 1


[file2.rb]
$var = 0
require "file1.rb"
require "file1.rb"
puts $var
```
1. 0
2. 1
3. 2
4. 実行時にエラーが発生する

requireはライブラリを読み込むメソッドです。同一のファイルを指定しても2回読み込まれません。
そのため，2.となる.


問41．以下の2つのコードの実行結果の出力として正しいものを選択してください。

```ruby
[コード1]
class Foo
 Const = "foo"
 def foo
  puts Const
 end
end
Foo.new.foo


[コード2]
module M
 def foo
  puts Const
 end
end
class Foo
 Const = "foo"
 include M
end
Foo.new.foo
```

コード1のfooメソッドはクラス内で定義した定数Constを参照しておりますので、エラーになりません。
コード2のfooメソッドはモジュール内で定義した定数Constを参照してしまい、未定義なのでエラーになります。
よって3.

問42．以下の2つのコードの実行結果の出力として正しいものを選択してください。
```ruby
[コード1]
class Foo
 def foo
  puts "foo"
 end
end
class Bar < Foo
 def foo
  puts "bar"
 end
end
class Bar
 undef_method :foo
end
Bar.new.foo


[コード2]
class Foo
 def foo
  puts "foo"
 end
end
class Bar < Foo
 def foo
  puts "bar"
 end
end
class Bar
 remove_method :foo
end
Bar.new.foo
```

1. [コード1]
foo
[コード2]
bar
2. [コード1]
bar
[コード2]
foo
3. [コード1]
foo
[コード2]
エラーになる
4. [コード1]
エラーになる
[コード2]
foo

解説
コード１でfooメソッドは未定義化されておりますのでメソッド呼び出し時にエラーになります。
コード2では、メソッドの未定義化にremove_methodを使用しておりますが、このメソッドはスーパークラスに同名のメソッドがある場合にそれが呼ばれるので、エラーになりません。
よって4.


__参考__
undef_methodメソッドは、クラスやモジュールのメソッドを未定義にして、呼び出せなくします。引数にはメソッド名をシンボルか文字列で指定します（複数指定できます）。戻り値はクラスやモジュール自身です。
```ruby
class Cat
  def greet() "meow" end
end

cat = Cat.new
puts cat.greet
Cat.class_eval { undef_method :greet }
puts cat.greet rescue p $!
meow
#<NoMethodError: undefined method `greet' for #<Cat:0x59a400>>
```
親クラスのメソッドをサブクラスで未定義にした場合は、undef_methodを呼び出したクラスとそのサブクラスでメソッドを呼び出せなくなります。ただし、親クラスのメソッドには影響しません。
undef_methodメソッドは、クラスやモジュールからメソッドを削除します。引数にはメソッド名をシンボルか文字列で指定します（複数指定できます）。戻り値はクラスやモジュール自身です。

undef_methodメソッドとは違い、削除できるのはそのクラス・モジュールで定義されたメソッドだけです。親クラスのメソッドは指定できません。また、削除したメソッドと同名のメソッドが親クラスにある場合は、親クラスのメソッドが呼び出されるようになります。

問43．以下のコードの実行結果として正しいものを選択してください
```ruby
[コード]
 class Foo
  def foo
   "foo"
  end
 end


 class Bar < Foo
  def foo
   super + "bar"
  end
  alias bar foo
  undef foo
 end
 puts Bar.new.bar
```
aliasはメソッドに別名をつけるためのキーワードです。
undefはメソッドを未定義化するためのキーワードです。
問題文中のコードでは、fooメソッドが定義された後に未定義化されておりますので、fooメソッドの呼び出しでは、superによって問題なく親クラスの同名のメソッドが呼ばれます。

問44．以下の結果を出力するコードとして\__(1)\__にあてはまるものを選択してください。

```ruby
[コード]
 CONST = "message1"
 class Foo
  CONST = "message2"
  def foo
   puts __(1)__
  end
 end
 Foo.new.foo
[実行結果]
 message1
```
1. CONST
2. ::CONST
3. CONST::
4. :CONST:

解説
定数名の先頭の「::」はトップレベルを表し、「::Const」でトップレベルにある定数を参照することができます。
よって2.


問45．クラス変数の説明として正しいものを選択してください。
1. クラス変数の変数名の先頭には「@」を付ける必要がある
2. クラス変数はインスタンス毎に独立した値を保持できる
3. クラス変数の変数名の先頭には「@@」を付ける必要がある
4. クラス変数はプログラムのどこからでも参照することができる
解答：３

問46．以下のコードを実行した結果から、\__(1)\__にあてはまる正しいものを選択してください。

```ruby
[コード]
 class Person
  def initialize(name)
   @name = name
  end
  def __(1)__
   "My name is #{@name}"
  end
 end
 p Person.new("taro")


[実行結果]
 My name is taro.
```
1. p
2. to_s
3. inspect
4. toString

inspectメソッドはpメソッドでオブジェクトそのものを出力した際の文字列表現を指定するメソッドです。よって3.

問47．FileTestモジュールに存在しないメソッドを選択してください。

1. file?
2. directory?
3. socket?
4. child?

  解答：４

  解説
  FileTestモジュールはファイルやディレクトリの検査を行う機能をまとめたモジュールです。

問48．下記のコードの説明として正しいものを選択してください。
```ruby
[コード]
 class Foo
  def initialize(obj)
   obj.foo
  end
  def foo
   puts "foofoofoo"
  end
 end
 class Bar
  def foo
   puts "barbarbar"
  end
 end
 Foo.new(Bar.new)
```
1. このコードを実行すると「foofoofoo」と出力される
2. このコードを実行すると「barbarbar」と出力される
3. このコードを実行するとシンタックスエラーになる
4. このコードを実行すると呼び出されるメソッドが存在しないためエラーになる

解答:2

問49．下記のコードの実行結果として正しいものを選択してください
```ruby
[コード]
 class Bar
  def foo
   puts "barbarbar"
  end
 end
 class Foo < Bar
  def initialize(obj)
   obj.foo
  end
  def foo
   puts "foofoofoo"
  end
 end
 Foo.new(Foo.new(Bar.new))
```
1. foofoofoo
2. barbarbar
3. foofoofoo
barbarbar
4. barbarbar
foofoofoo

解答：４

問50．以下のコードの実行結果として正しいものを選択してください。

[コード]
 p Class.superclass
1. エラーになる
2. Object
3. Class
4. Module
  解説
  ClassクラスのスーパークラスはModuleクラスです。

問51．以下のコードの説明として正しいものを選択してください。
```ruby
[コード]
 class Foo
  private
  def foo
   puts "foofoofoo"
  end
 end
 puts Foo.new.respond_to?(:foo)
```
1. このコードを実行すると「foofoofoo」が出力される
2. このコードを実行すると「true」が出力される
3. このコードを実行すると「false」が出力される
4. 引数には文字列を指定すべきなので実行するとエラーになる

  解説
  respond_to?メソッドは、レシーバが引数で指定した名前のpublicメソッドを持っているか調べるメソッドです。第2引数にtrueを指定すれば、指定した名前のprivateメソッドを持っているかを調べることができます。

  問52．webrickライブラリの説明として正しいものを選択してください。

  1. webrickは組込みライブラリなので「require 'webrick'」を記述しなくても使用できる
  2. webrickライブラリは、Webサーバを実装するためのライブラリでRuby on Railsでも使用されている
  3. webrickライブラリはSSL通信に対応していない
  4. webrickライブラリを使用する場合は、gemなどでインストールする必要がある
  解答：２

組み込みライブラリはrequireする必要がない．webricは組み込みライブラリでないため,requireする必要がある.webrickはSSL通信に対応している.gemでインストールする必要はない.

問53．以下のコードの説明として正しいものを選択してください。
```ruby
[コード]
 require 'socket'
 p TCPSocket.ancestors.member?(IO)
```
1. このコードを実行すると「true」が出力される
2. このコードを実行すると「false」が出力される
3. socketライブラリは組込みライブラリなので「require 'socket'」を記述する必要はない
4. socketライブラリにTCPSocketというクラスは存在しない

__解説__  
TCPSocketはIOクラスを継承しており、Fileクラスなどと同様な操作でソケットを扱うことができます。

よって1
問55．以下のコードで誤りのある行を選択してください。

[コード]
```ruby
 1: i = 0
 2: while i <= 5 do
 3:  print i
 4:  ++i
 5: end
 ```
1. 1
2. 2
3. 3
4. 4
__解説__  
rubyには「++i」という構文はありません。インクリメントする場合は「i += 1」などと記述します

問56．以下の実行結果を出力するコードとして\__(1)\__にあてはまるものを選択してください。
```ruby
[コード]
 class Log
  [:debug, :info, :notice].each do |level|
   __(1)__(level) do
    @state = level
   end
  attr_reader :state
 end
 log = Log.new
 log.debug  ; p log.state
 log.info   ; p log.state
 log.notice ; p log.state


[実行結果]
 :debug
 :info
 :notice
```
1. method_define
2. define_method
3. send
4. __send__

define_methodメソッドは引数で指定した名前のメソッドを定義するためのメソッドです。

問57．以下のコードを実行したときの出力結果として正しいものを選択してください。
```ruby
[コード]
 var = lambda { puts "hello" }
 p var.class
```

lambdaキーワードはProcオブジェクトを生成するためのキーワードです。
そのため,3

問58．以下のコードの説明として正しいものを選択してください。
```ruby
[コード]
 1: module M
 2:  def foo
 3:   puts "foo"
 4:  end
 5: end
 6:
 7: class Foo
 8:  extend M
 9: end
 10:
 11: Foo.new.foo
```
1. 実行すると「foo」と出力される
2. 8行目でエラーになる
3. 11行目でエラーになる
4. 実行すると「nil」と出力される

  解説
  extendはモジュールで定義したメソッドをクラスメソッドとして追加しますので、メソッドを呼び出す場合は、「Foo.foo」と記述する必要があります。

  問59．Marshalモジュールの説明として正しいものを選択してください。

  1. Rubyで扱うすべてのオブジェクトをシリアライズすることができる
  2. Marshalモジュールはそれ自身がオブジェクトをファイルに記録する機能を持っている
  3. IOオブジェクトや特異メソッドを持つオブジェクトはシリアライズすることができない
  4. Marshalモジュールは「require 'marshal'」を記述して使用することができる
  問59の解答
  解答：３

  問60．標準添付ライブラリによって提供されていないクラスを選択してください。

  1. TCPSocket
  2. Thread
  3. Test::Unit
  4. Swap
  問60の解答
  解答：４
## Ruby Program

単因子論
Programでみる線形代数
微積分
ひとまず,線形代数を定義するか...

ベクトル空間




### mathtodon
Dockerの使い方含め調査中.
