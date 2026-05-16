output_path <- file.path("docs", "session_info.txt")
dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

sink(output_path)
cat("Session information captured on:", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), "\n\n")
print(sessionInfo())
cat("\nLoaded namespaces:\n")
print(sort(loadedNamespaces()))
sink()

cat("Wrote:", output_path, "\n")
