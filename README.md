## Synopsis

This is `dateseq`, a utility to generate sequences of dates.

## Installation

Use `stack install` as usual.  The executable will be named `dateseq`.

## Usage

There are three arguments: a start date, an end date, and an optional
set of days of the week, introduced by the `-d` or `-dows` flag.
To only consider Monday, Wednesday, and Friday, use `-d MWF`.
Saturday is `A`, and Thursday is `R` in this scheme.

The dates (for now) use `YYYY-MM-DD` format.

## Example

All the Thursdays in December 2019:

```shell
% dateseq 2019-12-01 2019-12-31 -d R
2019-12-05
2019-12-12
2019-12-19
2019-12-26
```

All the Thursdays in December
