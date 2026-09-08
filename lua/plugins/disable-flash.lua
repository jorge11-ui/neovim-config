-- Disable flash.nvim: its `s` mapping crashs with
-- "Invalid cursor column: out of range". Restores native `s` (substitute).
return {
  { "folke/flash.nvim", enabled = false },
}
