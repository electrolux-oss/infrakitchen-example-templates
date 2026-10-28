# Drift detection and reconcile

A no-cloud module for trying InfraKitchen drift detection: **Check drift**, the **Drift** tab, **Reconcile**, **Accept** and template **drift ignore rules**.

Files stand in for cloud objects. The module writes two files with the `local` provider:

| Object | File |
|---|---|
| `local_file.app_config` | `<drift_dir>/<name>/app-config.json` |
| `local_file.welcome` | `<drift_dir>/<name>/welcome.txt` |

`terraform_data.release` exists only in the state, so it never drifts and acts as a control object.

`drift_dir` (default `/tmp/infrakitchen-drift-demo`) must be **outside the task workspace**, because InfraKitchen deletes the workspace after every task. The files are written on the machine or container that runs the InfraKitchen worker.

## Limitations

- The `local` provider reports both a deleted file and an edited file as **"has been deleted"**. The Drift tab therefore shows the objects as *deleted*, without an attribute table. Cloud objects, such as tags changed on an S3 bucket, show *changed* with the old and new attribute values.
- Run a single worker, or point `drift_dir` at a directory every worker shares. A drift check that runs on a worker without the files reports them as deleted.

## Walkthrough

1. **Import** the template `test/07-drift-reconcile` and create a resource. Use a unique `name` per resource. Run **Apply** and wait for `provisioned`. The outputs show the file paths.
2. **No drift yet.** In the resource, open **More → Check drift**. The **Drift** tab appears and shows *In sync*.
3. **Make drift.** On the worker, delete one file and edit the other:
   ```sh
   rm /tmp/infrakitchen-drift-demo/demo/app-config.json
   echo "edited by hand" > /tmp/infrakitchen-drift-demo/demo/welcome.txt
   ```
   For a worker in a container, prefix the commands with `docker exec <worker>` or `kubectl exec <worker-pod> --`.
4. **Detect it.** Run **Check drift** again. The tab shows *Drifted* with `local_file.app_config` and `local_file.welcome` marked *deleted*. You get one *drift detected* notification; later checks that find the same drift don't send another.
5. **Reconcile.** In the Drift tab, click **Reconcile → Dry run**. The plan in the logs creates both files again. Then click **Reconcile → Apply**. The files are back with their configured content:
   ```sh
   cat /tmp/infrakitchen-drift-demo/demo/welcome.txt
   # Managed by InfraKitchen. Edit or delete me to create drift.
   ```
   After the apply, the tab marks the old result as *outdated*. The next check (scheduled or manual) shows *In sync*.

## Also try

- **Accept** (resource admins only). Delete `welcome.txt`, run **Check drift**, then click **Accept**. The state forgets the deleted file, and the tab shows *In sync* with "1 drifted object was accepted". The configuration is unchanged, so the next **Apply** creates the file again. That is the difference from Reconcile. If you delete another file between the check and Accept, Accept stops and asks for a new check.
- **Ignore rules.** In the template sidebar, add the drift ignore rule `local_file.welcome`. Edit `welcome.txt` and run **Check drift**. The result is *In sync*, with "1 change ignored by the drift ignore rules of the template". Attribute rules such as `aws_autoscaling_group.*: desired_capacity` only make sense for providers that report changed attributes; this module's drift is always a deletion.
- **Scheduled checks.** Turn on drift detection in **Administration → Drift Detection**, or in the project's settings. Resources are then checked every *interval* hours, and a resource applied since its last check is checked first.

## Pass criteria

- Check drift on an untouched resource shows *In sync*, and the resource status doesn't change.
- After the files are changed, Check drift shows both files as *deleted* and sends one notification.
- Reconcile → Apply restores both files, and the next check shows *In sync*.
- Accept forgets the deleted file without changing the infrastructure; the next apply creates it again.
