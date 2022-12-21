use itertools::Itertools;
use std::{collections::HashSet, ops::RangeInclusive};

use euclid::default::Point2D;
use nom::{
    bytes::complete::{tag, take_until},
    character::complete::newline,
    combinator::map_res,
    multi::many1,
    IResult,
};

fn manhattan_distance(pt1: &Point2D<i64>, pt2: &Point2D<i64>) -> u64 {
    pt1.x.abs_diff(pt2.x) + pt1.y.abs_diff(pt2.y)
}

#[derive(Debug, Clone, Copy)]
struct Sensor {
    position: Point2D<i64>,
    closest_beacon: Point2D<i64>,
}

impl Sensor {
    pub fn manhattan_distance_to_beacon(&self) -> u64 {
        manhattan_distance(&self.position, &self.closest_beacon)
    }

    pub fn distance_from_edge_of_signal_to_y(&self, y: i64) -> i64 {
        let distance_to_y = self.position.y.abs_diff(y);
        let manhattan_distance = self.manhattan_distance_to_beacon();
        manhattan_distance as i64 - distance_to_y as i64
    }

    pub fn positions_covered_at_y(&self, y: i64) -> Option<RangeInclusive<i64>> {
        let distance_from_edge = self.distance_from_edge_of_signal_to_y(y);
        if distance_from_edge >= 0 {
            Some(self.position.x - distance_from_edge..=self.position.x + distance_from_edge)
        } else {
            None
        }
    }
}

fn parse_line(input: &str) -> IResult<&str, Sensor> {
    let (input, _) = tag("Sensor at x=")(input)?;
    let (input, sensor_x) = map_res(take_until(","), |s: &str| s.parse::<i64>())(input)?;
    let (input, _) = tag(", y=")(input)?;
    let (input, sensor_y) = map_res(take_until(":"), |s: &str| s.parse::<i64>())(input)?;
    let (input, _) = tag(": closest beacon is at x=")(input)?;
    let (input, beacon_x) = map_res(take_until(","), |s: &str| s.parse::<i64>())(input)?;
    let (input, _) = tag(", y=")(input)?;
    let (input, beacon_y) = map_res(take_until("\n"), |s: &str| s.parse::<i64>())(input)?;
    let (input, _) = newline(input)?;
    Ok((
        input,
        Sensor {
            position: euclid::point2(sensor_x, sensor_y),
            closest_beacon: euclid::point2(beacon_x, beacon_y),
        },
    ))
}

fn parse_input(input: &str) -> IResult<&str, Vec<Sensor>> {
    many1(parse_line)(input)
}

fn part_1(sensors: &[Sensor], y_to_check: i64) -> usize {
    let beacons = sensors
        .iter()
        .map(|sensor| sensor.closest_beacon)
        .filter(|beacon| beacon.y == y_to_check)
        .collect::<HashSet<_>>();

    let positions_covered = sensors
        .iter()
        .filter_map(|sensor| sensor.positions_covered_at_y(y_to_check))
        .sorted_by(|lhs, rhs| lhs.start().cmp(rhs.start()))
        .reduce(|acc, range| *acc.start().min(range.start())..=*acc.end().max(range.end()))
        .unwrap();
    positions_covered.into_iter().count() - beacons.len()
}

fn part_2(sensors: &[Sensor], search_grid_size: usize) -> usize {
    for y in 0usize..=search_grid_size {
        let positions_covered = sensors
            .iter()
            .filter_map(|sensor| sensor.positions_covered_at_y(y as i64))
            .sorted_by(|lhs, rhs| lhs.start().cmp(rhs.start()))
            .collect_vec();

        let (head, tail) = positions_covered.split_first().unwrap();
        let mut accumulator = head.clone();
        for range in tail {
            if range.end() <= accumulator.end() {
                continue;
            }
            if *range.start() > accumulator.end() + 1 {
                return (*accumulator.end() as usize + 1) * 4_000_000 + y;
            }
            accumulator = *accumulator.start()..=*range.end();
        }
    }

    panic!("Distress beacon not found");
}

fn main() {
    let input = include_str!("../input.txt");
    let sensors = parse_input(input).unwrap().1;
    println!(
        "Positions covered at 2000000: {}",
        part_1(&sensors, 2_000_000)
    );
    println!("Tuning frequency: {}", part_2(&sensors, 4_000_000));
}

#[cfg(test)]
mod test {
    use super::*;

    const INPUT: &str = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
";

    #[test]
    fn test_part_1() {
        let sensors = parse_input(INPUT).unwrap().1;
        assert_eq!(part_1(&sensors, 10), 26);
    }

    #[test]
    fn test_part_2() {
        let sensors = parse_input(INPUT).unwrap().1;
        // println!("{}", part_2(&sensors, 20));
        assert_eq!(part_2(&sensors, 20), 56000011);
    }
}
