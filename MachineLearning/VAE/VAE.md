# VAE

生成モデルは機械学習の広い範囲で扱われている。
それは、データセット
$X$
これはおそらく裏に新の高次元の分布
$X$
があると想定している。
(同じ
$X$
で書いてほしくないなぁ)
を用いて扱われる。
$P(X)$
から定義される確率。
例えば画像は生成モデルを作るときに使われる一番有名なデータの例である。
このとき
$X$
は複数の画像がなす集合である。
任意の画像は何千、あるいは、何万の次元?のデータを持つ。(次元の定義があいまいに適当に使われるののも好きじゃないなぁ)
生成系モデルの役割はピクセル(データ)間の関係をなんらかの方法で発見することである。
(ここでいうデータは何万の次元?のデータの1次元の部分のことを指す。
そのため、もともとのデータという言葉は不一致であることに注意)
生成モデルの単純な作り方は入力データをもとに数値的に
$P(X)$を数えることである。
画像の場合は
$X$
はランダムなノイズ画像が発生する確率は低く、本当の画像によく似たものが高い確率で得られるようになるべきである。しかし、このようなモデルは、役に立つ必要はない。
knowing that one image is unlikely does
not help us synthesize one that is likely.
訳せない。どういう意味?


those already in a database, but not exactly the same. We could start with a
database of raw images and synthesize new, unseen images.
We might take
in a database of 3D models of something like plants and produce more of
them to fill a forest in a video game.
We could take handwritten text and try
to produce more handwritten text. Tools like this might actually be useful
for graphic designers.
We can formalize this setup by saying that we get
examples X distributed according to some unknown distribution Pgt(X),
and our goal is to learn a model P which we can sample from, such that P is
as similar as possible to Pgt.
imilar as possible to Pgt.
Training this type of model has been a long-standing problem in the machine
learning community, and classically, most approaches have had one of
three serious drawbacks. First, they might require strong assumptions about
the structure in the data. Second, they might make severe approximations,
leading to suboptimal models. Or third, they might rely on computationally
expensive inference procedures like Markov Chain Monte Carlo. More
recently, some works have made tremendous progress in training neural
networks as powerful function approximators through backpropagation [9].
These advances have given rise to promising frameworks which can use
backpropagation-based function approximators to build generative models.
One of the most popular such frameworks is the Variational Autoencoder
[1, 3], the subject of this tutorial. The assumptions of this model are
weak, and training is fast via backpropagation. VAEs do make an approximation,
but the error introduced by this approximation is arguably small
given high-capacity models. These characteristics have contributed to a
quick rise in their popularity.
This tutorial is intended to be an informal introduction to VAEs, and not
a formal scientific paper about them. It is aimed at people who might have
uses for generative models, but might not have a strong background in the
variatonal Bayesian methods and “minimum description length” coding
models on which VAEs are based. This tutorial began its life as a presentation
for computer vision reading groups at UC Berkeley and Carnegie Mellon,
and hence has a bias toward a vision audience. Suggestions for improvement
are appreciated.


##  1.1 Preliminaries: Latent Variable Models
When training a generative model, the more complicated the dependencies
between the dimensions(?)(画像の1ピクセル同士の依存関係を指して、次元と言っている?)
, the more difficult the models are to train. Take,
for example, the problem of generating images of handwritten characters.
Say for simplicity that we only care about modeling the digits 0-9. If the left
half of the character contains the left half of a 5, then the right half cannot
contain the left half of a 0, or the character will very clearly not look like any
real digit. Intuitively, it helps if the model first decides which character to
generate before it assigns a value to any specific pixel. This kind of decision
is formally called a latent(潜在) variable. That is, before our model draws anything,
it first randomly samples a digit value(?) z from the set [0, ..., 9], and then makes
sure all the strokes match that character. z is called ‘latent’ because given
just a character produced by the model, we don’t necessarily know which
settings of the latent variables generated the character. We would need to
infer it using something like computer vision.
Before we can say that our model is representative of our dataset,
we need to make sure that for every datapoint
$X$
in the dataset, there is one (or
many) settings of the latent variables which causes the model to generate something very similar to
$X$.
Formally, say we have a vector of latent
variables z in a high-dimensional space Z which we can easily sample
according to some probability density function (PDF) P(z) defined over Z.
Then, say we have a family of deterministic(??)決定的でない関数などあるのか？ functions f(z; θ), parameterized
by a vector θ in some space Θ, where f : Z × Θ → X . f is deterministic, but
if z is random and θ is fixed, then f(z; θ) is a random variable in the space
X .
$X$は確率空間なのか？確率空間だとすると集合は確率全体に一致するのでは?
 We wish to optimize θ such that we can sample z from P(z) and, with
high probability, f(z; θ) will be like the X’s in our dataset.
To make this notion precise mathematically, we are aiming maximize the
probability of each X in the training set under the entire generative process,
according to:
P
