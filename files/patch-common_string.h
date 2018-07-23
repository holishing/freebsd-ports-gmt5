Index: src/common_string.h
===================================================================
--- src/common_string.h	(revision 20454)
+++ src/common_string.h	(working copy)
@@ -82,7 +82,9 @@
 
 EXTERN_MSC int gmt_match_string_in_file (const char *filename, const char *string);
 
+#ifndef __FreeBSD__
 EXTERN_MSC char *basename(char *path);
+#endif
 
 #ifdef __cplusplus
 }
