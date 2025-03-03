# Remote repo
UPSTREAM := upstream
BRANCH := main

UPSTREAM_BRANCH := $(UPSTREAM) $(BRANCH)
UPSTREAM_BRANCH_SLASH := $(UPSTREAM)/$(BRANCH)
DIRS_TO_RESTORE := $(shell git ls-tree -d --name-only HEAD)


# Fetch latest changes from upstream
__fetch:
	echo "git fetch $(UPSTREAM_BRANCH)"
	@git fetch $(UPSTREAM_BRANCH) > /dev/null
	@echo ""

# Merge upstream into branch
__merge:
	@echo "git merge $(UPSTREAM_BRANCH_SLASH)"
	@git merge $(UPSTREAM_BRANCH_SLASH) > /dev/null || true
	@echo ""

# Merge only new root folders from upstream that don't exist in current HEAD
__restore_dirs:
	@for dir in $(DIRS_TO_RESTORE); do \
		echo "Restore: $$dir"; \
		git checkout --ours -- "$$dir"; \
		git restore --recurse-submodules --source=HEAD -- "$$dir"; \
		git add "$$dir"; \
	done
	@for dir in $(shell git ls-tree -d --name-only $(UPSTREAM_BRANCH_SLASH)); do \
		if [ -d "$$dir" ] && [ "$$(echo $$dir | head -c 1)" = "." ]; then \
			if [ "$$(git ls-tree -d HEAD $$dir)" = "" ]; then \
				echo "Drop changes: $$dir"; \
				git rm -rf "$$dir" > /dev/null ; \
				git clean -df "$$dir" > /dev/null ; \
			fi; \
		fi; \
	done
	@echo ""

__after_restoration_conflicts:
	@echo "Conflicts: "
	@git status --short | grep -E '^(.U|U.|AA|DD)'

# Full merge process
update-modules: __fetch __merge __restore_dirs __after_restoration_conflicts

# Reset back to before the make update-modules
reset:
	git reset --hard
	@echo ""


check-updates:
	@for dir in $(shell git ls-tree -d --name-only $(UPSTREAM_BRANCH_SLASH)); do \
		if [ -d "$$dir" ] && [ "$$(echo $$dir | head -c 1)" != "." ]; then \
			if [ "$$(git ls-tree -d HEAD $$dir)" = "" ]; then \
				echo "New version of Go image $$dir available on $$(git remote get-url $(UPSTREAM))"; \
				exit 1; \
			fi; \
		fi; \
	done