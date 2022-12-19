use core::str::FromStr;
use std::{fmt::Display, fs::File, io::Write, iter};

use nom::{
    bytes::complete::tag,
    character::complete::{char, digit1, newline},
    combinator::map_res,
    multi::separated_list1,
    sequence::separated_pair,
    IResult,
};

#[derive(Debug, Clone, Copy)]
#[repr(u8)]
enum SpaceType {
    Empty = b' ',
    Rock = b'#',
    Sand = b'O',
}

impl SpaceType {
    pub fn occupied(self) -> bool {
        matches!(self, Self::Rock | Self::Sand)
    }
}

#[derive(Debug, Clone, Copy)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug, Clone)]
struct Map {
    boundaries: Boundaries,
    grid: Vec<Vec<SpaceType>>,
}

impl Map {
    pub fn new(boundaries: Boundaries, sections_list: Vec<Vec<Point>>) -> Self {
        let offset_x = boundaries.min_x as usize;
        let mut grid: Vec<Vec<SpaceType>> = iter::repeat_with(|| {
            iter::repeat(SpaceType::Empty)
                .take(boundaries.width_inclusive() as usize)
                .collect()
        })
        .take((1 + boundaries.max_y) as usize)
        .collect();

        for sections in sections_list {
            for (last_point, current_point) in
                sections.windows(2).map(|points| (points[0], points[1]))
            {
                if last_point.y == current_point.y {
                    for x in last_point.x.min(current_point.x) as usize
                        ..=last_point.x.max(current_point.x) as usize
                    {
                        grid[last_point.y as usize][x - offset_x] = SpaceType::Rock
                    }
                } else if last_point.x == current_point.x {
                    for y in last_point.y.min(current_point.y) as usize
                        ..=last_point.y.max(current_point.y) as usize
                    {
                        grid[y][current_point.x as usize - offset_x] = SpaceType::Rock
                    }
                }
            }
        }
        Self { boundaries, grid }
    }

    pub fn with_floor(&self) -> Self {
        let mut map = self.clone();
        map.boundaries.max_y += 2;
        map.grid.push(
            iter::repeat(SpaceType::Empty)
                .take(map.boundaries.width_inclusive() as usize)
                .collect(),
        );
        map.grid.push(
            iter::repeat(SpaceType::Rock)
                .take(map.boundaries.width_inclusive() as usize)
                .collect(),
        );
        map
    }

    pub fn drop_sand(&mut self) -> DropResult {
        let mut current_x = 500;
        for (y, row) in self.grid.iter_mut().enumerate() {
            let x = (current_x - self.boundaries.min_x) as usize;
            if row[x].occupied() {
                if current_x - 1 < self.boundaries.min_x || current_x + 1 > self.boundaries.max_x {
                    return DropResult::OutOfBounds;
                } else if row[x - 1].occupied() && row[x + 1].occupied() {
                    self.grid[y - 1][x] = SpaceType::Sand;
                    return if y == 1 && current_x == 500 {
                        DropResult::Full
                    } else {
                        DropResult::InsideBounds
                    };
                } else if !row[x - 1].occupied() {
                    current_x -= 1
                } else if !row[x + 1].occupied() {
                    current_x += 1
                }
            }
        }

        DropResult::OutOfBounds
    }

    pub fn expand_horizontally(&mut self) {
        self.boundaries.min_x -= 10;
        self.boundaries.max_x += 10;

        let (last, rows) = self.grid.split_last_mut().unwrap();
        for row in &mut rows.iter_mut() {
            let new_row = iter::repeat(SpaceType::Empty)
                .take(10)
                .chain(row.clone())
                .chain(iter::repeat(SpaceType::Empty).take(10))
                .collect::<Vec<_>>();
            *row = new_row;
        }
        *last = iter::repeat(SpaceType::Rock)
            .take(self.boundaries.width_inclusive() as usize)
            .collect();
    }
}

impl Display for Map {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        for row in &self.grid {
            f.write_str(
                row.iter()
                    .map(|b| *b as u8 as char)
                    .collect::<String>()
                    .as_str(),
            )?;
            f.write_str("\n")?;
        }
        Ok(())
    }
}

#[derive(Debug)]
enum DropResult {
    OutOfBounds,
    InsideBounds,
    Full,
}

#[derive(Debug, Clone, Copy)]
struct Boundaries {
    min_x: i32,
    min_y: i32,
    max_x: i32,
    max_y: i32,
}

impl Boundaries {
    pub fn new() -> Self {
        Self {
            min_x: i32::MAX,
            min_y: i32::MAX,
            max_x: i32::MIN,
            max_y: i32::MIN,
        }
    }

    pub fn width_inclusive(&self) -> i32 {
        1 + self.max_x - self.min_x
    }
}

fn parse_point<'a>(input: &'a str, boundaries: &mut Boundaries) -> IResult<&'a str, Point> {
    let (input, (x, y)) = map_res(
        separated_pair(digit1, char(','), digit1),
        |(x, y): (&str, &str)| -> Result<_, <i32 as FromStr>::Err> {
            Ok((x.parse::<i32>()?, y.parse::<i32>()?))
        },
    )(input)?;

    boundaries.min_x = boundaries.min_x.min(x);
    boundaries.min_y = boundaries.min_y.min(y);
    boundaries.max_x = boundaries.max_x.max(x);
    boundaries.max_y = boundaries.max_y.max(y);
    Ok((input, Point { x, y }))
}

fn parse_line<'a>(input: &'a str, boundaries: &mut Boundaries) -> IResult<&'a str, Vec<Point>> {
    separated_list1(tag(" -> "), |input| parse_point(input, boundaries))(input)
}

fn parse_input<'a>(
    input: &'a str,
    boundaries: &mut Boundaries,
) -> IResult<&'a str, Vec<Vec<Point>>> {
    separated_list1(newline, |input| parse_line(input, boundaries))(input)
}

fn part_1(mut map: Map) {
    let mut sand_count = 0;
    while let DropResult::InsideBounds = map.drop_sand() {
        sand_count += 1;
    }
    let mut map_file = File::create("map.txt").unwrap();
    write!(map_file, "{}", map).unwrap();
    println!("Sand count when out of bounds: {}", sand_count);
}

fn part_2(mut map: Map) {
    let mut sand_count = 0;
    loop {
        let drop_result = map.drop_sand();
        match drop_result {
            DropResult::Full => {
                sand_count += 1;
                break;
            }
            DropResult::InsideBounds => {
                sand_count += 1;
            }
            DropResult::OutOfBounds => {
                map.expand_horizontally();
            }
        }
    }

    let mut map_file = File::create("map_full.txt").unwrap();
    write!(map_file, "{}", map).unwrap();
    println!("Sand count when full: {}", sand_count)
}

fn main() {
    let input = include_str!("../input.txt");
    let mut boundaries = Boundaries::new();
    let sections_list = parse_input(input, &mut boundaries).unwrap().1;
    let map = Map::new(boundaries, sections_list);
    part_1(map.clone());
    part_2(map.with_floor());
}

#[cfg(test)]
mod test {
    use super::*;

    const INPUT: &str = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9";

    #[test]
    fn test_part_1() {
        let mut boundaries = Boundaries::new();
        let sections_list = parse_input(INPUT, &mut boundaries).unwrap().1;
        let mut map = Map::new(boundaries, sections_list);
        let mut sand_count = 0;
        while let DropResult::InsideBounds = map.drop_sand() {
            sand_count += 1;
        }
        println!("{}", map);
        assert_eq!(sand_count, 24);
    }

    #[test]
    fn test_part_2() {
        let mut boundaries = Boundaries::new();
        let sections_list = parse_input(INPUT, &mut boundaries).unwrap().1;
        // println!("{:#?}", sections_list);
        let mut map = Map::new(boundaries, sections_list).with_floor();
        println!("{}", map);
        let mut sand_count = 0;
        loop {
            let drop_result = map.drop_sand();
            match drop_result {
                DropResult::Full => {
                    sand_count += 1;
                    break;
                }
                DropResult::InsideBounds => {
                    sand_count += 1;
                }
                DropResult::OutOfBounds => {
                    map.expand_horizontally();
                }
            }
            if sand_count == 100 {
                break;
            }
        }
        println!("{}", map);
        assert_eq!(sand_count, 93);
    }
}
