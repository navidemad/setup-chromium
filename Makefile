# Makefile for running GitHub Action (.github/workflows/ci-local.yml) jobs with act

#TRUNKS := continuous snapshots
TRUNKS := continuous

# Default target for running all combinations of matrix jobs
all: run_matrix_jobs

# Helper target to run matrix jobs
run_matrix_jobs: $(TRUNKS)
	@echo "Completed running all matrix jobs."

# Target for each trunk variable
$(TRUNKS):
	@echo "Running job for trunk: $@"
	$(MAKE) run_job TRUNK=$@ PLATFORM=catthehacker/ubuntu:full-latest

run_job:
	@echo "Running job for trunk: $(TRUNK) on platform: $(PLATFORM)"
	act --list
	@ACT_PLATFORM=$(PLATFORM) act -j local --container-architecture linux/amd64 --env TRUNK=$(TRUNK) --env PLATFORM=$(PLATFORM)

# Helper target to set up environment for cross-architecture emulation
setup-emulation:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Clean up target for removing any artifacts or temporary files
clean:
	@echo "Clean up completed."

# Phony targets for make commands to work correctly without file name conflicts
.PHONY: all run_matrix_jobs $(TRUNKS) setup-emulation clean
