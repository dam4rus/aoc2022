use std::{cmp::Ordering};

use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
#[serde(untagged)]
enum PacketData {
    Int(i32),
    List(Vec<PacketData>),
}

impl PartialEq for PacketData {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Int(lhs), Self::Int(rhs)) => lhs == rhs,
            (Self::List(lhs), Self::List(rhs)) => lhs == rhs,
            (Self::Int(single), Self::List(list)) | (Self::List(list), Self::Int(single)) => vec![Self::Int(*single)] == *list,
        }
    }
}

impl Eq for PacketData {
    
}

impl Ord for PacketData {
    fn cmp(&self, other: &Self) -> Ordering {
        match (self, other) {
            (PacketData::Int(lhs), PacketData::Int(rhs)) => lhs.cmp(rhs),
            (PacketData::List(lhs), PacketData::List(rhs)) => lhs.cmp(rhs),
            (PacketData::Int(single), PacketData::List(list)) => vec![PacketData::Int(*single)].cmp(list),
            (PacketData::List(list), PacketData::Int(single)) => list.cmp(&vec![PacketData::Int(*single)]),
        }
    }
}

impl PartialOrd for PacketData {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

#[derive(Debug, Clone, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
struct Packet(Vec<PacketData>);

fn main() {
    let input = include_str!("../input.txt");

    let mut packets = input.split("\n")
            .filter(|line| !line.is_empty())
            .map(|packet| serde_json::from_str(packet))
            .collect::<Result<Vec<Packet>, _>>()
            .unwrap();

    let sum: usize = packets.chunks_exact(2)
        .enumerate()
        .filter(|(_, pair)| matches!(pair[0].cmp(&pair[1]), Ordering::Less))
        .map(|(i, _)| i + 1)
        .sum();
    println!("Sum of properly ordered: {}", sum);

    let divider1 = Packet(vec![PacketData::List(vec![PacketData::Int(2)])]);
    let divider2 = Packet(vec![PacketData::List(vec![PacketData::Int(6)])]);
    packets.push(divider1.clone());
    packets.push(divider2.clone());
    packets.sort();

    let product: usize = packets.iter()
        .enumerate()
        .filter(|(_, packet)| **packet == divider1 || **packet == divider2)
        .map(|(i, _)| i + 1)
        .product();
    println!("Product of divider indexes: {}", product);
}

#[cfg(test)]
mod test {
    use std::vec;

    use super::*;

    const INPUT: &str = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]";

    #[test]
    fn test_part_1() {
        let packets = INPUT.split("\n")
            .filter(|line| !line.is_empty())
            .map(|packet| serde_json::from_str(packet))
            .collect::<Result<Vec<Packet>, _>>().unwrap();

        let sum: usize = packets.chunks_exact(2)
            .enumerate()
            .filter(|(_, pair)| matches!(pair[0].cmp(&pair[1]), Ordering::Less))
            .map(|(i, _)| i + 1)
            .inspect(|i| println!("{}", i))
            .sum();

        assert_eq!(sum, 13);
    }

    #[test]
    fn test_part_2() {
        let mut packets = INPUT.split("\n")
            .filter(|line| !line.is_empty())
            .map(|packet| serde_json::from_str(packet))
            .collect::<Result<Vec<Packet>, _>>().unwrap();
        let divider1 = Packet(vec![PacketData::List(vec![PacketData::Int(2)])]);
        let divider2 = Packet(vec![PacketData::List(vec![PacketData::Int(6)])]);
        packets.push(divider1.clone());
        packets.push(divider2.clone());
        packets.sort();

        let product: usize = packets.iter()
            .enumerate()
            .filter(|(_, packet)| **packet == divider1 || **packet == divider2)
            .map(|(i, _)| i + 1)
            .product();
        assert_eq!(product, 140);
    }
}