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
#### <a name="exists?"> exists?
#### <a name="foreach"> foreach
#### <a name="getwd"> getwd
#### <a name="pwd"> pwd
#### <a name="home"> home
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

__解説__ 1.は整数型となるため0となるる.3は有理数型であり,`to_f`すれば0.8になる.

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




## Ruby Program

単因子論
Programでみる線形代数
微積分
ひとまず,線形代数を定義するか...

ベクトル空間




### mathtodon
Dockerの使い方含め調査中.
