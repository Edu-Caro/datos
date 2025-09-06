prinfact <- function(x,r=2)
{
  k   <- ncol(x) # N?mero de variables
  comp=c('Comp 1'); for (i in 2:r) comp = c(comp,paste('Comp', i)) 
  nam <- c(comp,'communality','uniquiness')
  sol <- matrix(0,k,r+2) # matriz de correlaciones
  res <- matrix(0,3,r)  # Varianza explicada 
  rownames(sol)<-colnames(x) # Nombre de las variables
  
  # Cálculo
  
  eig <- eigen(cor(x))
  fit = princomp(x,cor=TRUE)
  eig$vectors = unclass(loadings(fit))
  imp <- eig$values/sum(eig$values)
  cum <- cumsum(imp)
  
  
  if ( eig$vectors[1,1] < 0 )  {eig$vectors = -eig$vectors}
  fac <- eig$vectors%*%diag(sqrt(eig$values))
  sol[1:k,1:r] <- fac[,1:r];
  com <- diag(fac[,1:r]%*%t(fac[,1:r]))
  uni <- 1- com
  
  z = scale(x) # estandariza las variables
  z_scores = z%*%eig$vectors # calcula los scores
  
  sol[1:k,r+1] = t(com)
  sol[1:k,r+2] = t(uni)
  res[1,1:r] = eig$values[1:r]
  res[2,1:r] = imp[1:r]
  res[3,1:r] = cum[1:r]
  colnames(sol)<-nam
  rownames(res)=c('Variance','Proportion','Cumulative')
  colnames(res)=comp
  list(loadings = sol,variances = res,scores=z_scores,eig=eig)
}

