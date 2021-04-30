[1mdiff --git a/vbm3d_test.m b/vbm3d_test.m[m
[1mnew file mode 100644[m
[1mindex 0000000..0c1f81b[m
[1m--- /dev/null[m
[1m+++ b/vbm3d_test.m[m
[36m@@ -0,0 +1,23 @@[m
[32m+[m[32mclc;[m
[32m+[m[32mclear;[m
[32m+[m[32mclose all;[m
[32m+[m
[32m+[m[32maddpath("yuv4mpeg2mov");[m
[32m+[m[32maddpath("BM3D");[m
[32m+[m
[32m+[m[32mmov = yuv4mpeg2mov("data/akiyo_qcif.y4m");[m
[32m+[m
[32m+[m[32mframe1 = mov(1).cdata;[m
[32m+[m[32m% imshow(frame1);[m
[32m+[m
[32m+[m[32mframes = zeros([size(frame1, 1) size(frame1, 2) size(mov,2)], 'uint8');[m
[32m+[m[32mfor i=1:size(mov, 2)[m
[32m+[m[32m    frames(:,:,i) = rgb2gray(mov(i).cdata) + cast(randn(size(frame1, 1), size(frame1, 2))*20, 'uint8');[m
[32m+[m[32mend[m
[32m+[m
[32m+[m[32m[~, x]  = VBM3D(frames, 20);[m
[32m+[m
[32m+[m[32mfor i=1:5[m
[32m+[m[32m    figure;[m
[32m+[m[32m    imshow([x(:,:,i)*255 rgb2gray(mov(i).cdata) frames(:,:,i)]);[m
[32m+[m[32mend[m
