use std::collections::HashSet;

use euclid::{default::Point2D, point2};
use nom::{
    bytes::complete::{tag, take_until},
    character::complete::newline,
    combinator::map_res,
    multi::many1,
    IResult,
};

#[derive(Debug, Clone, Copy)]
struct Sensor {
    position: Point2D<i32>,
    closest_beacon: Point2D<i32>,
}

impl Sensor {
    pub fn manhattan_distance_to_beacon(&self) -> u32 {
        self.position.x.abs_diff(self.closest_beacon.x)
            + self.position.y.abs_diff(self.closest_beacon.y)
    }

    pub fn distance_from_edge_of_signal_to_y(&self, y: i32) -> i32 {
        let distance_to_y = self.position.y.abs_diff(y);
        let manhattan_distance = self.manhattan_distance_to_beacon();
        manhattan_distance as i32 - distance_to_y as i32
    }

    pub fn positions_covered_at_y(&self, y: i32) -> HashSet<Point2D<i32>> {
        let distance_from_edge = self.distance_from_edge_of_signal_to_y(y);
        if distance_from_edge >= 0 {
            (self.position.x - distance_from_edge..=self.position.x + distance_from_edge)
                .map(|x| point2(x, y))
                .collect()
        } else {
            HashSet::new()
        }
    }
}

fn parse_line(input: &str) -> IResult<&str, Sensor> {
    let (input, _) = tag("Sensor at x=")(input)?;
    let (input, sensor_x) = map_res(take_until(","), |s: &str| s.parse::<i32>())(input)?;
    let (input, _) = tag(", y=")(input)?;
    let (input, sensor_y) = map_res(take_until(":"), |s: &str| s.parse::<i32>())(input)?;
    let (input, _) = tag(": closest beacon is at x=")(input)?;
    let (input, beacon_x) = map_res(take_until(","), |s: &str| s.parse::<i32>())(input)?;
    let (input, _) = tag(", y=")(input)?;
    let (input, beacon_y) = map_res(take_until("\n"), |s: &str| s.parse::<i32>())(input)?;
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

fn main() {
    let input = include_str!("../input.txt");
    let sensors = parse_input(input).unwrap().1;
    let beacons = sensors
        .iter()
        .map(|sensor| sensor.closest_beacon)
        .filter(|beacon| beacon.y == 2_000_000)
        .collect::<HashSet<_>>();
    let positions_covered = sensors.into_iter().fold(HashSet::new(), |acc, sensor| {
        acc.union(&sensor.positions_covered_at_y(2_000_000))
            .copied()
            .collect()
    });
    let positions_covered = positions_covered
        .symmetric_difference(&beacons)
        .collect::<HashSet<_>>();
    println!("Positions covered at 2000000: {}", positions_covered.len());
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
Sensor at x=20, y=1: closest beacon is at x=15, y=3";

    #[test]
    fn test_part_1() {
        let sensors = parse_input(INPUT).unwrap().1;
        let beacons = sensors
            .iter()
            .map(|sensor| sensor.closest_beacon)
            .filter(|beacon| beacon.y == 10)
            .collect::<HashSet<_>>();
        let positions_covered = sensors.into_iter().fold(HashSet::new(), |acc, sensor| {
            acc.union(&sensor.positions_covered_at_y(10))
                .copied()
                .collect()
        });
        let positions_covered = positions_covered
            .symmetric_difference(&beacons)
            .collect::<HashSet<_>>();
        assert_eq!(positions_covered.len(), 26);
    }
}
