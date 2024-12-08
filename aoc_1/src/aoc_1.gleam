import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type Numbers =
  #(List(Int), List(Int))

pub fn main() {
  let assert Ok(records) = simplifile.read(from: "./input.txt")

  splitlocations(records)
  |> sort
  |> linedistance
  |> list.fold(0, int.add)
  |> io.debug
}

// Calculate distance
fn linedistance(numbers: Numbers) -> List(Int) {
  list.map2(numbers.0, numbers.1, fn(num1, num2) -> Int {
    int.absolute_value(num1 - num2)
  })
}

// Sort
fn sort(numbers: Numbers) -> Numbers {
  #(list.sort(numbers.0, int.compare), list.sort(numbers.1, int.compare))
}

// Input formatting
fn splitlocations(lines: String) -> Numbers {
  splitlists(string.split(lines, "\n"), #(list.new(), list.new()))
}

fn splitlists(lines: List(String), accumulator: Numbers) -> Numbers {
  case lines {
    [x, ..rest] -> splitline(x, splitlists(rest, accumulator))
    [] -> accumulator
  }
}

fn splitline(line: String, accumulator: Numbers) -> Numbers {
  case line {
    "" -> accumulator
    _ ->
      fn() -> Numbers {
        let locations = string.split(line, "   ")
        let assert Ok(firstitem) = list.first(locations)
        let assert Ok(firstlocation) = int.parse(firstitem)
        let assert Ok(seconditem) = list.last(locations)
        let assert Ok(secondlocation) = int.parse(seconditem)
        #([firstlocation, ..accumulator.0], [secondlocation, ..accumulator.1])
      }()
  }
}