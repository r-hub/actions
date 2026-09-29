# Generate test workflows from the example workflows of the *BSD actions.
# Run `make` in this directory after changing an example workflow.

WORKFLOWS := ../.github/workflows
BSDS := freebsd openbsd netbsd dragonflybsd
TESTS := $(patsubst %,$(WORKFLOWS)/test-setup-r-%.yaml,$(BSDS))

all: $(TESTS)

define workflow_rule
$(WORKFLOWS)/test-setup-r-$(1).yaml: ../setup-r-$(1)/$(1).yaml make-workflow.pl
	perl make-workflow.pl setup-r-$(1) < $$< > $$@
endef

$(foreach bsd,$(BSDS),$(eval $(call workflow_rule,$(bsd))))

# Fail if the generated workflows are not up to date.
check: all
	git diff --exit-code -- $(WORKFLOWS)

clean:
	rm -f $(TESTS)

.PHONY: all check clean
