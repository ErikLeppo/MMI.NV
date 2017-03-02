#' Rarify
#' 
#' This function allows you to generate a fixed subsample.
#' 
#'rarify function:
#' R function to rarify (subsample) a macroinvertebrate sample down to a fixed count;
#' by John Van Sickle, USEPA. email: VanSickle.John@epa.gov    ;
#'Version 1.0, 06/10/05;
#' 
#' See rarify.help.txt for function documentation;
#' See rarify.examples.r.txt for examples of usage;
####################################################
#' Modifications to generate reproducible subsamples.  Set the seed for the random number generator to a fixed number.
#' Erik.Leppo@tetratech.com (2016)
#############################################################################
#' @param inbug data frame of SampleID, Count, and TaxaCode
#' @param sample.ID data frame field with sample ID
#' @param abund data frame field with number of individuals
#' @param subsiz  target subsample size
#' @return Returns the original data frame with an additional column for count
#' @keywords rarify, subsample, Nevada, NV, MMI
#' @examples
#' # Location of files.
#'path <- getwd()
#' setwd(path)
#' 
#' library("MMIcalcNV")
#' 
#' # read in test data
#'#bugnew.raw <- read.csv(file="bugsamples.csv")
#'bugnew.raw <- NV.bugs
#'head(bugnew.raw)
#'#aggregate samples by bug code and sample
#'bugnew.raw <- bugnew.raw[,c("Samp_Rep","Individuals","TaxaID_Stage")]
#'bugnew.raw.ag <- aggregate(Individuals~TaxaID_Stage+Samp_Rep,data=bugnew.raw,sum)
#'#resample to 300 counts
#'bugnew.300cnt <- rarify(inbug=bugnew.raw.ag, sample.ID="Samp_Rep", abund="Individuals", subsiz=300)
#'# remove taxa with a count of zero
#'bugnew.300cnt <- bugnew.300cnt[bugnew.300cnt$Count>0,]
#' @export
# FUNCTION - rarify
rarify<-function(inbug, sample.ID, abund, subsiz){
  # set seed so can reproduce.  Use state's date of admission to the Union.
  mySeed <- 18641031
  #
  start.time=proc.time();
  outbug<-inbug;
  sampid<-unique(inbug[,sample.ID]);
  nsamp<-length(sampid);
  #parameters are set up;
  #zero out all abundances in output data set;
  outbug[,abund]<-0;
  #loop over samples, rarify each one in turn;
  #
  for(i in 1:nsamp) { ;
    #extract current sample;
    isamp<-sampid[i];
    flush.console();
    #print(as.character(isamp));
    onesamp<-inbug[inbug[,sample.ID]==isamp,];
    onesamp<-data.frame(onesamp,row.id=seq(1,dim(onesamp)[[1]])); #add sequence numbers as a new column;
    #expand the sample into a vector of individuals;
    samp.expand<-rep(x=onesamp$row.id,times=onesamp[,abund]);
    nbug<-length(samp.expand); #number of bugs in sample;
    #vector of uniform random numbers;
    set.seed(mySeed)
    ranvec<-runif(n=nbug);
    #sort the expanded sample randomly;
    samp.ex2<-samp.expand[order(ranvec)];
    #keep only the first piece of ranvec, of the desired fised count size;
    #if there are fewer bugs than the fixed count size, keep them all;
    if(nbug>subsiz){subsamp<-samp.ex2[1:subsiz]} else{subsamp<-samp.ex2};
    #tabulate bugs in subsample;
    subcnt<-table(subsamp);
    #define new subsample frame and fill it with new reduced counts;
    newsamp<-onesamp;
    newsamp[,abund]<-0;
    newsamp[match(newsamp$row.id,names(subcnt),nomatch=0)>0,abund]<-as.vector(subcnt);
    outbug[outbug[,sample.ID]==isamp,abund]<-newsamp[,abund];
  }; #end of sample loop;
  #
  #elaps<-proc.time()-start.time;
  #print(c("Rarefaction complete. Number of samples = ",nsamp),quote=F);
  #print(c("Execution time (sec)= ", elaps[1]),quote=F);
  outbug; #return subsampled data set as function value;
}; #end of function;
