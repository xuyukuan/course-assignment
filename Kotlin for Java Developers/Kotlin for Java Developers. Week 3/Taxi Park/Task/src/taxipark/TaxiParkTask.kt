package taxipark

/*
 * Task #1. Find all the drivers who performed no trips.
 */
fun TaxiPark.findFakeDrivers(): Set<Driver> =
        this.allDrivers.filter { d -> this.trips.none { t -> t.driver == d } }.toSet()

/*
 * Task #2. Find all the clients who completed at least the given number of trips.
 */
fun TaxiPark.findFaithfulPassengers(minTrips: Int): Set<Passenger> =
        if (minTrips == 0) this.allPassengers
        else this.trips.flatMap { t -> t.passengers }
                .groupingBy { it }
                .eachCount()
                .filter { it.value >= minTrips }
                .map { it.key }.toSet()

/*
 * Task #3. Find all the passengers, who were taken by a given driver more than once.
 */
fun TaxiPark.findFrequentPassengers(driver: Driver): Set<Passenger> =
        this.trips.filter { it.driver == driver }
                .flatMap { it.passengers }
                .groupingBy { it }
                .eachCount()
                .filter { it.value > 1 }
                .map { it.key }.toSet()

/*
 * Task #4. Find the passengers who had a discount for majority of their trips.
 */
fun TaxiPark.findSmartPassengers(): Set<Passenger> =
        this.allPassengers.filter { p ->
            this.trips.filter { p in it.passengers && it.discount != null }.count() >
            this.trips.filter { p in it.passengers && it.discount == null }.count()
        }.toSet()

/*
 * Task #5. Find the most frequent trip duration among minute periods 0..9, 10..19, 20..29, and so on.
 * Return any period if many are the most frequent, return `null` if there're no trips.
 */
fun TaxiPark.findTheMostFrequentTripDurationPeriod(): IntRange? {
    return this.trips.map { t ->
        val start = (t.duration / 10) * 10
        val end = start + 9
        IntRange(start, end)
    }.groupingBy { it }.eachCount().maxBy { it.value }?.key
}

/*
 * Task #6.
 * Check whether 20% of the drivers contribute 80% of the income.
 */
fun TaxiPark.checkParetoPrinciple(): Boolean {
    if (this.trips.isEmpty())
        return false
    val total = this.allDrivers.size
    val top20 = (0.2 * total).toInt()
    val list = this.trips.groupingBy { it.driver }.aggregate {_, acc: Double?, e, first ->
        if (first) {
            e.cost
        } else {
            acc!! + e.cost
        }
    }.entries.sortedByDescending { it.value }
    val totalIncome = list.sumByDouble { it.value ?: 0.0 }
    val top20Income = list.take(top20).sumByDouble { it.value ?: 0.0 }
    return top20Income >= (totalIncome * 0.8)
}