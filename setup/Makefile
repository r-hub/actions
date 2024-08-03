
test:
	NOT_CRAN=true TESTTHAT_EDITION=3 R -q -e 'testthat::test_file("platforms.R")'

snapshot-review:
	R -q -e 'testthat::snapshot_review(path = ".")'
