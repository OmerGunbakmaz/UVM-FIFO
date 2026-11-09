# FIFO Verification Plan

**DUT:** `rtl/fifo.sv`, synchronous FIFO, `DEPTH = 8`, `WIDTH = 8`
**Source of truth:** the DUT decisions in the header of `rtl/fifo.sv` (not the RTL body)
**Simulators:** Questa FSE (local, no `randomize`/`covergroup`), Xcelium on EDA Playground (coverage)

## Spec summary

| Spec item | Text |
|---|---|
| S1 | Single clock, active-low reset `rst_n` |
| S2 | `DEPTH = 8`, `WIDTH = 8` |
| S3 | A write when `full` is ignored |
| S4 | A read when `empty` is ignored |
| S5 | `rdata` is registered: valid one cycle after an accepted read |
| S6 | Read and write in the same cycle are both accepted if allowed; a write is blocked only when `full` and there is no read |

## Features

| ID | Feature | Spec | How it is checked | Coverage | Test |
|---|---|---|---|---|---|
| F1 | Data comes out in the same order it went in, unchanged | — | Scoreboard: pop reference queue on each accepted read, compare with `rdata` | `cp_level`, `cx_op_state` | all |
| F2 | After reset: `empty = 1`, `full = 0` | S1 | Scoreboard: flag check on the first cycle after reset | `cp_reset_flags` | all |
| F3 | `full` is high exactly when 8 entries are stored | S2 | Scoreboard: every cycle, `full == (queue.size() == 8)` | `cp_level` bin `full` | fill_drain, random |
| F4 | `empty` is high exactly when 0 entries are stored | S2 | Scoreboard: every cycle, `empty == (queue.size() == 0)` | `cp_level` bin `empty` | fill_drain, random |
| F5 | Write when full (no read) is ignored: no data stored, level unchanged | S3 | Monitor does not publish the write; F1 and F3 then catch any stored data | `cx_op_state`: `wr_only × full` | fill_drain, random |
| F6 | Read when empty is ignored: no data returned, level unchanged | S4 | Monitor does not publish the read; scoreboard flags an error if a read arrives while the reference queue is empty | `cx_op_state`: `rd_only × empty` | fill_drain, random |
| F7 | `rdata` is valid one cycle after the accepted read | S5 | Monitor samples `rdata` one cycle after the accepted read; a wrong timing shows up as F1 mismatches | — (always exercised) | all |
| F8 | Read and write together, FIFO neither full nor empty: both accepted, level unchanged | S6 | F1 + F3/F4 | `cx_op_state`: `wr_rd × mid` | rw, random |
| F9 | Read and write together while full: both accepted, stays full | S6 | F1 + F3 | `cx_op_state`: `wr_rd × full` | rw, random |
| F10 | Read and write together while empty: only the write accepted | S4, S6 | F1 + F4; monitor publishes only the write | `cx_op_state`: `wr_rd × empty` | rw, random |
| F11 | Pointer wraparound: data stays correct after more than 8 writes in total | S2 | F1 over a long run | `cp_wraps` | fill_drain, rw, random |
| F12 | Full → not full and empty → not empty transitions work | S3, S4 | F3, F4 | `cp_level` transition bins | fill_drain |

## Coverage model

One covergroup, sampled **every clock cycle** after reset (not only on accepted transactions; F5, F6 and F10 are cycles where something is *not* accepted).

| Name | What | Bins |
|---|---|---|
| `cp_level` | Number of entries in the reference model | `empty` = 0, `low` = 1–3, `high` = 4–7, `full` = 8; transitions `0 => 1`, `8 => 7`, `7 => 8`, `1 => 0` |
| `cp_op` | Request this cycle: `{wr_en, rd_en}` | `idle`, `wr_only`, `rd_only`, `wr_rd` |
| `cp_state` | FIFO state at the start of the cycle | `empty`, `mid`, `full` |
| `cx_op_state` | `cp_op × cp_state` | all 12 combinations (`idle` bins may be ignored) |
| `cp_wraps` | How many times the write side has gone past 8 entries in total | `1`, `2`, `3+` |
| `cp_reset_flags` | Flags in the first cycle after reset | `empty = 1, full = 0` |

**Goal:** 100% on all of the above in the random test, or every hole explained in this file.

## Tests

| Test | Stimulus | Mainly covers |
|---|---|---|
| `fifo_base_test` | 5 writes, then 5 reads | smoke, F1, F2, F7 |
| `fifo_fill_drain_test` | Write until full plus a few extra, then read until empty plus a few extra | F3–F6, F11, F12 |
| `fifo_rw_test` | Continuous simultaneous read/write at different fill levels | F8–F10 |
| `fifo_random_test` | Random `wr_en`, `rd_en`, `wdata` over many cycles | everything, coverage closure |
| `fifo_override_test` | Same as random, with a factory override (e.g. a write-heavy sequence item) | reaches `full` more often |

## Bug injection (proof that the checks work)

| Define | Expected to be caught by |
|---|---|
| `BUG_FULL_OFF_BY_ONE` | F3 flag check |
| `BUG_WRITE_WHEN_FULL` | F1 data compare, F3 flag check |
| `BUG_PTR_WRAP` | F1 data compare (needs F11 wraparound) |

## Out of scope

- Assertions (SVA): added later, after the assertions chapter.
- Reset in the middle of traffic: the spec does not say what happens to stored data. Open question, see below.
- Other `DEPTH`/`WIDTH` values: only the default parameters are verified.

## Open questions for the spec owner

1. What is the value of `rdata` after reset, and while no read happens? (Assumed: holds the last value; not checked.)
2. Is reset during traffic required to clear the FIFO? (Assumed: yes, not tested.)
