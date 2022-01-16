FA <- function(intput, winterDC = NULL)
{
  
  if(is.null(winterDC))
  {
    test.fwi <- fwi(IRAWS1)
  }
  else
  {
    test.fwi <- fwi(IRAWS1, winterDC)
  }
  
  return(test.fwi)
}

