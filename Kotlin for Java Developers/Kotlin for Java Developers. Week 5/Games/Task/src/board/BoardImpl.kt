package board

import board.Direction.*
import java.lang.IllegalArgumentException

fun createSquareBoard(width: Int): SquareBoard = SquareBoardImpl(width).init()
fun <T> createGameBoard(width: Int): GameBoard<T> = GameBoardImpl<T>(width).init()

open class SquareBoardImpl(override val width: Int) : SquareBoard {
    private var cells: Array<Array<Cell>> = arrayOf(arrayOf())
    override fun getCellOrNull(i: Int, j: Int): Cell? =
            when {
                i <= 0 || i > width || j <= 0 || j > width -> null
                else -> getCell(i, j)
            }

    override fun getCell(i: Int, j: Int): Cell =
            when {
                i <= 0 || i > width || j <= 0 || j > width -> throw IllegalArgumentException()
                else -> cells[i - 1][j - 1]
            }

    override fun getAllCells(): Collection<Cell> =
            IntRange(1, width).flatMap { i -> IntRange(1, width).map { j -> getCell(i, j) } }.toList()

    override fun getRow(i: Int, jRange: IntProgression): List<Cell> =
            jRange.mapNotNull { j -> getCellOrNull(i, j) }.toList()

    override fun getColumn(iRange: IntProgression, j: Int): List<Cell> =
            iRange.mapNotNull { i -> getCellOrNull(i, j) }.toList()

    override fun Cell.getNeighbour(direction: Direction): Cell? =
            when (direction) {
                UP -> getCellOrNull(i - 1, j)
                LEFT -> getCellOrNull(i, j - 1)
                DOWN -> getCellOrNull(i + 1, j)
                RIGHT -> getCellOrNull(i, j + 1)
            }

    open fun init(): SquareBoardImpl {
        if (width > 0) {
            cells = IntRange(1, width).map { i -> IntRange(1, width).map { j -> Cell(i, j) }.toTypedArray() }.toTypedArray()
        }
        return this
    }
}

class GameBoardImpl<T>(override val width: Int) : SquareBoardImpl(width), GameBoard<T> {
    private val cellValues = mutableMapOf<Cell, T?>()
    override fun get(cell: Cell): T? = cellValues[cell]

    override fun set(cell: Cell, value: T?) {
        cellValues[cell] = value
    }

    override fun filter(predicate: (T?) -> Boolean): Collection<Cell> =
            cellValues.filterValues(predicate).keys

    override fun find(predicate: (T?) -> Boolean): Cell? = filter(predicate).first()

    override fun any(predicate: (T?) -> Boolean): Boolean = cellValues.values.any(predicate)

    override fun all(predicate: (T?) -> Boolean): Boolean = cellValues.values.all(predicate)

    override fun init(): GameBoardImpl<T> {
        super.init()
        getAllCells().forEach { set(it, null) }
        return this
    }
}