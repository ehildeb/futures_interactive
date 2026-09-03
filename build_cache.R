# build_cache.R
# Regenerates data/globals_cache.rds from source data files.
#
# Run from the futures_interactive/ directory:
#   Rscript build_cache.R
#
# After running, commit the updated data/globals_cache.rds to git.
# Posit Connect will pick it up at the next deploy, skipping all heavy
# processing at startup.
#
# When to re-run:
#   - Any source data file in data/ changes
#   - node_positions_manual.csv is updated
#   - Data processing logic in global.R changes

t0 <- proc.time()
message("build_cache.R: starting full data processing...")

options(rebuild_cache = TRUE)
source("global.R")

elapsed <- (proc.time() - t0)[["elapsed"]]
message(sprintf("build_cache.R: done in %.1fs -- commit data/globals_cache.rds to git", elapsed))

