# =============================================================================
# Purge stale data
# =============================================================================

# -----------------------------------------------------------------------------
# Downloaded
# -----------------------------------------------------------------------------

# remove zip files
zips_to_delete <- fs::dir_ls(
    path = comm_download_dir, 
    recurse = FALSE, 
    type = "file", 
    regexp = "\\.zip$"
)
fs::file_delete(zips_to_delete)

# remove unzipped folders and the data they contain
dirs_to_delete <- fs::dir_ls(
    path = comm_download_dir, 
    recurse = FALSE, 
    type = "directory"
)
fs::dir_delete(dirs_to_delete)

# -----------------------------------------------------------------------------
# Combined
# -----------------------------------------------------------------------------

# remove dta files
dtas_to_delete <- fs::dir_ls(
    path = comm_combined_dir,
    recurse = FALSE,
    type = "file",
    regexp = "\\.dta"
)
fs::file_delete(dtas_to_delete)

# =============================================================================
# Get data
# =============================================================================

susoflows::download_matching(
    matches = rapport_params$masque_comm, 
    workspace = rapport_params$workspace, 
    export_type = "STATA", 
    path = comm_download_dir
)
