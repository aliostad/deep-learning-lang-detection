2009-03-26  Shaun Jackman  <sjackman@gmail.com>

	* ompi/mpi/c/request_get_status.c (MPI_Request_get_status):
	Do not fail if the status argument is NULL, because the
	application may pass MPI_STATUS_IGNORE for the status argument.

--- ompi/mpi/c/request_get_status.c.orig	2008-11-04 12:56:27.000000000 -0800
+++ ompi/mpi/c/request_get_status.c	2009-03-26 14:00:00.807344000 -0700
@@ -49,7 +49,7 @@
 
     if( MPI_PARAM_CHECK ) {
         OMPI_ERR_INIT_FINALIZE(FUNC_NAME);
-        if( (NULL == flag) || (NULL == status) ) {
+        if (NULL == flag) {
             return OMPI_ERRHANDLER_INVOKE(MPI_COMM_WORLD, MPI_ERR_ARG, FUNC_NAME);
         } else if (NULL == request) {
             return OMPI_ERRHANDLER_INVOKE(MPI_COMM_WORLD, MPI_ERR_REQUEST,