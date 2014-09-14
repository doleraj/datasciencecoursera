#Merges the training and the test sets to create one data set.
loadAndMergeData <- function (datafolder) {
    
    currentDirectory <- getwd();
    setwd(datafolder)
    
    # Get the column names.
    columnNames <- read.table("features.txt")
    
    # Allow caching of the results, as loading can take a while.
    if (!exists("testDataCache")) {
        testDataCache <<- makeFolderCache("test", columnNames)
    }
    if (!exists("trainDataCache")) {
        trainDataCache <<- makeFolderCache("train", columnNames)
    }
    
    # Get the cached data or load new data.
    testdata <- loadFolderData(testDataCache)
    traindata <- loadFolderData(trainDataCache)
    
    setwd(currentDirectory)
    
    # Combine the rows and return.
    rbind(testdata, traindata)
}

# Constructs a caching object so we can just store the loaded data once we have it.
makeFolderCache <- function(directory, columnNames) {
    cachedData <- NULL
    set <- function(newData) {
        cachedData <<- newData
    }
    get <- function() cachedData
    getDirectory <- function() directory
    getColumnNames <- function() {
        columnNames[,2]
    }
    list(set = set, get = get, 
         getColumnNames = getColumnNames, getDirectory = getDirectory)
}

# Loads the actual folder data, from the cache or from disk.
loadFolderData <- function(cache) {
    data = cache$get()
    if (!is.null(data)) {
        return(data)
    } else {
        currentDir <- getwd()
        directory <- cache$getDirectory()
        setwd(directory);
        
        mainData <- read.fwf(paste("X_", directory, ".txt", sep = ""), 
                                        widths = rep(16, 561), col.names = cache$getColumnNames())
        labelData <- read.table(paste("y_", directory, ".txt", sep = ""), col.names = c("ActivityID"))
        userData <- read.table(paste("subject_", directory, ".txt", sep = ""), col.names = c("Subject"))
        
        data <- cbind(userData, cbind(mainData, labelData))
        data <- tbl_df(data)
        cache$set(data)
        
        setwd(currentDir)
        data
    }
}