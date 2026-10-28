# A real object outside of tofu, so a refresh-only plan can find drift.
# The dummy modules only use terraform_data and random_id, which have no external
# object, so they can never drift.
#
# To cause drift, delete the file on the machine that runs the worker:
#   rm <dir>/<name>.txt
# Then run "Check drift": the plan reports `local_file.managed has been deleted`.

resource "local_file" "managed" {
  filename = "${var.dir}/${var.name}.txt"
  content  = var.content
}
