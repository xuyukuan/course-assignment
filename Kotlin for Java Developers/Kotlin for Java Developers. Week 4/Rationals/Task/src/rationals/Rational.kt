package rationals

import java.math.BigInteger

class Rational(val n: BigInteger, val d: BigInteger) : Comparable<Rational> {
    operator fun plus(r: Rational): Rational = ((n * r.d) + (r.n * d)) divBy (r.d * d)

    operator fun minus(r: Rational): Rational = ((n * r.d) - (r.n * d)) divBy (r.d * d)

    operator fun times(r: Rational): Rational = (n * r.n) divBy (d * r.d)

    operator fun div(r: Rational): Rational = (n * r.d) divBy (d * r.n)

    operator fun unaryMinus(): Rational = Rational(-n, d)

    override fun compareTo(r: Rational): Int = (n * r.d).compareTo(r.n * d)

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        other as Rational
        return this.toString() == other.toString()
    }

    override fun toString(): String {
        val gcd = this.n.gcd(this.d)
        val reverse = this.d < 0.toBigInteger()
        val simpleN = (if (reverse) -this.n else this.n) / gcd
        val simpleD = (if (reverse) -this.d else this.d) / gcd
        return if (simpleD.toInt() == 1) simpleN.toString() else "$simpleN/$simpleD"
    }
}

infix fun Int.divBy(d: Int): Rational = Rational(this.toBigInteger(), d.toBigInteger())

infix fun BigInteger.divBy(d: BigInteger) = Rational(this, d)

infix fun Long.divBy(d: Long): Rational = Rational(this.toBigInteger(), d.toBigInteger())

fun String.toRational(): Rational {
    val values = this.split("/")
    return when {
        values.size == 1 -> Rational(values[0].toBigInteger(), 1.toBigInteger())
        values.size == 2 && values[1] != "0" -> Rational(values[0].toBigInteger(), values[1].toBigInteger())
        else -> throw IllegalArgumentException()
    }
}

fun main() {
    val half = 1 divBy 2
    val third = 1 divBy 3

    val sum: Rational = half + third
    println(5 divBy 6 == sum)

    val difference: Rational = half - third
    println(1 divBy 6 == difference)

    val product: Rational = half * third
    println(1 divBy 6 == product)

    val quotient: Rational = half / third
    println(3 divBy 2 == quotient)

    val negation: Rational = -half
    println(-1 divBy 2 == negation)

    println((2 divBy 1).toString() == "2")
    println((-2 divBy 4).toString() == "-1/2")
    println("117/1098".toRational().toString() == "13/122")

    val twoThirds = 2 divBy 3
    println(half < twoThirds)

    println(half in third..twoThirds)

    println(2000000000L divBy 4000000000L == 1 divBy 2)

    println("912016490186296920119201192141970416029".toBigInteger() divBy
            "1824032980372593840238402384283940832058".toBigInteger() == 1 divBy 2)
}