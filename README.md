SPM_connectome
==============

Analysis of the data from the human connectome project with Statistical parametric mapping

This requires SPM12b in the directory.
Download human connctome project functional dataset (here the 'social cognition task') into a directory with plenty of diskspace

The scripts can be adapted to other tasks (e.g. motor or language task)

SPM Steps
1. Unpacking - run partial_unzipping_and_deletion_of_empty_folders.m - make sure you have the other functions in your path, this will unpack the tfMRI files needed for the SPM analysis

3. Smoothing - smooth functional files with 4mm gaussian kernel

4. 1st level analysis - run batch_social_firstlevel_job_pmod.m and add_pmod_contrasts.m to create first level analysis based on parametric modulators (for DCM).

You can also run batch_social_firstlevel_job_contrasts.m if you need t-contrasts instead of parametric modulators. 

5. 2nd Level analysis - here you can run an ANOVA which allows you to do 2nd level conjunction analysis but is less powerful or bring 1-level t-contrasts to the 2nd level (more statistical power)

DCM Steps

1. Extract VOIs for the DCM with VOI_extraction_pmod_model_2.m. You may want to check whether the voxels extract do not overlap with voi_overlap_check.m

2. Build and estimate the full model DCM with build_DCM_public.m

3. run_post_hoc_model.m to run exhaustive DCM