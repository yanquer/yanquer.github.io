#include <windows.h>
#include <stdio.h>

// 定义较长路径长度, 便于处理长路径
#define LONG_MAX_PATH 65535

/**
code支持的路径是 ASCII
*/

/**
win下当重命名的当前路径为长路径
跟内部一个GUI搭配, 存在 no protocol option 的报错, 暂时么找到原因
*/
static void RenameLongPath(const char* src_path, const char* target_path){
	char longSrcPath[strlen(path) + 8];
	char longTargetPath[strlen(path) + 8];

	if (strlen(path) > MAX_PATH) {
		sprintf(longSrcPath, "\\\\?\\%s", src_path);
		sprintf(longTargetPath, "\\\\?\\%s", target_path);
	} else {
		sprintf(longSrcPath, "%s", src_path);
		sprintf(longTargetPath, "%s", target_path);
	}

	if(MoveFileExA(longSrcPath, longTargetPath, MOVEFILE_REPLACE_EXISTING)){
		// 成功
	} else {
		// 失败
		DWORD errCode = GetLastError();
		char* errMsg = strerror(errCode);
		printf("Failed to rename dir %s, \nerror: %s\n", longSrcPath, errMsg);
	}
}

/**
删除空目录
*/
static void DeleteEmptyDir(const char* path){

	char longDir[strlen(path) + 8];
	if (strlen(path) > MAX_PATH) {
		// 长路径目录处理
		sprintf(longDir, "\\\\?\\%s", path);
	} else {
		// 正常路径
		sprintf(longDir, "%s", path);
	}

	// 删除目录
    if(RemoveDirectoryA(longDir)){
		printf("Remove dir %s success\n", longDir);
	} else {
		DWORD errCode = GetLastError();
		char* errMsg = strerror(errCode);
		printf("Failed to remove dir %s, \nerror: %s\n", longDir, errMsg);
	}
}

/**
删除文件, 支持长路径
*/
static void DeleteFileOrLong(const char* path){

	char longFile[strlen(path) + 8];
	if (strlen(path) > MAX_PATH) {
		// 长路径文件处理
		sprintf(longFile, "\\\\?\\%s", path);
	} else {
		// 正常长度
		sprintf(longFile, "%s", path);
	}

	// 删除文件
	if(DeleteFileA(longFile)){
		printf("Remove file %s success\n", longFile);
	}else{
		DWORD errCode = GetLastError();
		char* errMsg = strerror(errCode);
		printf("Failed to remove file %s, \nerror: %s\n", longFile, errMsg);
	}
}

/**
Windows适用
删除目录及下子文件/目录, 递归删除, 支持包含的路径为长路径
*/
void DeleteDirectory(const char* path) {
    WIN32_FIND_DATAA findData;
    HANDLE hFind;
    char fullPath[LONG_MAX_PATH];

    sprintf(fullPath, "\\\\?\\%s\\*", path);
    hFind = FindFirstFileA(fullPath, &findData);
    if (hFind == INVALID_HANDLE_VALUE) {
        return;
    }

    do {
        sprintf(fullPath, "%s\\%s", path, findData.cFileName);

        if (strcmp(findData.cFileName, ".") != 0 && strcmp(findData.cFileName, "..") != 0) {
            if (findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                DeleteDirectory(fullPath); // 递归删除子目录
            }
            else {
				// 删除文件
				DeleteFileOrLong(fullPath);
            }
        }
    } while (FindNextFileA(hFind, &findData));

    FindClose(hFind);

	// 删除目录
    DeleteEmptyDir(path);
}

int main() {
    const char* directoryPath = "C:\\path\\to\\directory";

    DeleteDirectory(directoryPath); // 调用函数删除目录及其内容

    return 0;
}

