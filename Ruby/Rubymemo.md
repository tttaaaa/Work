# Ruby Goldメモ

Ruby Gold合格に向け，Rubyの文法を学習する.
学習の記憶定着化のため,疑問点や内容をまとめたメモを作成する.
また,学習した知識を用いてRubyプログラムを作成する.
作りたいプログラムは以下の3つ.

- 代数系プログラム(単因子論,グレブナー基底,ガロア理論)
- Mathtodon改良(画像プログライン,Bot作成等)
- 機械学習ライブラリ

## 更新履歴
| 日付     | 概要    |
| :------------- | :------------- |
| 20170503    | ブロック(3-10)についてまとめる    |
| 20170504    | 問題1-11の解答/解説を作成 |
| 20170505    | 継承(4-1,4-2)の概略を記述  |

## Ruby基本

## 3-10 ブロックとProc
### 3-10-1 ブロックの基本
ブロックは新たにスコープを作成する.(スコープは作成するという?)
スコープとは,変数(等?)が参照できる範囲のこと.
ブロックの定義では後でし、使い方について説明する.
ブロックはメソッド呼び出しに記述し,yieldを使用することでブロックの内部で記述した処理を呼び出す.

__例__:
```ruby
def func x
  x + yield
end
p func(1){ 2 }
```
⇒3

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
はundefined local variable or method for main:Object(NameError)となる.

ブロック外で定義された変数をブロック内で参照、更新できる.
ブロック内で定義された変数はブロック外で参照できない.
### 3-10-2 ブロックのフォーマットと判定
{} or do end
の範囲内で定める.引数は||でくくって与える.
yieldの復帰値は,blockの最終行の結果.
ただしnextでブロックを抜けた場合はnilを返す.
またyield実行時にblockが与えられていない場合はLocalJumpErrorが発生する.
メソッド内でブロックが実施された場合とそうでない場合を分ける時はblock_given?をもって判定すればいい.

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
each等がある.例を記述するので覚えましょう.

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
でclassを定義できる.クラス名は、大文字で始める.(定数である必要があるので.)
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

## ライブラリ

## 問題集
### 基礎力確認問題
__問題1__. ruby -lオプションの説明として正しいものを全て選びなさい

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
