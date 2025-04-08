#-------------------- Workshop 3 Loops & Functions -------------------------

#loops repeat a set of code
#the for() loop is commonly used

for (i in 1:5) {  # create a for loop that runs 5 times (1 to 5)
  print(i)        # each time the for loop runs, print the value of i
}
#processes the code between {} every time it runs for a specified length
#in this example 1:5
# i is called the iterable and its value is determined in each loop by 
#the specified vector (1:5)
#the first time i is 1, 2nd time is 2, 3rd is 3 etc...


x <- 0            # make a new scalar called x with a value of 0

for (i in 1:10) { # create a for loop that runs 10 times (1 to 10)
  x <- x + i      # within our for loop we are adding the value of i to the value of x
}

print(x)          # print x
#the variable called x starts as 0 and then has the value of i added each time




#------------------------- Loop Questions ------------------
#1 - putting print() in the loop prints every single number in the loop
#2 
x <- 0           

for (i in 1:10) {
x <- x + i  
  }
print(x) 

#3
x <- 0
for (l in 1:10) {
  x <- x + l
}
print(x)

#4
x <- 0
for (i in 10:20) {
  x <- x + i
  print(x^2)
}
#--------------------- End of Questions -----------------


shrek_quote <- c('What', 'are', 'you', 'doing', 'in', 'my', 'swamp')
for (word in shrek_quote) {
  print(toupper(word))  #toupper makes lowercase capitals
}
#in this example the iterator is 'word'


for (donkey in 1:length(shrek_quote)) {
  print(toupper(shrek_quote[donkey]))  
}
#donkey is the iterator
#1:length() ensures that it covers the full quote?
#shrek_quote is the vector
#shrek_quote[donkey] is subsetting the quote to only print that part
# - even though it is the full thing




#Saving the output
output <- vector() # creates an empty vector that we can fill with values
input <- c('red', 'yellow', 'green', 'blue', 'purple')
for (i in 1:length(input)) {
  output[i] <- nchar(input[i])
}
print(output)
#outputting the number of characters in each colour - nchar() function


output <- vector()
fruit_chars <- c("apple","tangerine","kiwi","banana")
for (i in 1:length(fruit_chars)) { #i in 1:length makes it go through each item in the vector
  output[i] <- paste(fruit_chars[i], nchar(fruit_chars[i]), sep="_")
}
print(output)
#sep='' defines what will separate the items you are trying to paste together
#paste(x,y, sep='_'), output = x_y



#--------------------- Conditional Statements ----------------
#creating conditional statements using if()
numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i > 5){
    print(i)
  }
}

numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  }
}
#when i>5 is TRUE the loop runs the print(i) line following if()
#the conditional statement prints numbers that are less than 5 and divisible by 1
#by making use of {} 
#paste is combining the numbers <5 and integers with text explaining that

nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for (i in nums){
  if(i <25 & i %% 1 ==0 & i >0){
    print(paste(i, 'is less than 25, an integer and positive.', sep =''))
  }
}


#using else
numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  } else {
    print(paste(i, ' is not less than five or is not an integer (or both!).', sep = ''))
  }
}


nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for (i in nums){
  if(i <25 & i %% 1 ==0 & i >0){
    print(paste(i, 'is less than 25, an integer and positive.', sep =''))
  } else {
    print(paste(i, ' is one of not <25, not an integer, not positive or any combination'))
  }
}


#Using else if
numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  } else if(i < 5 & i %% 1 != 0){
    print(paste(i, ' is not an integer.', sep = ''))
  } else if(i >= 5 & i %% 1 == 0){
    print(paste(i, ' is not less than five.', sep = ''))
  } else {
    print(paste(i, ' is not less than five and is not an integer.', sep = ''))
  }
}


nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for (i in nums){
  if(i <25 & i %% 1 ==0 & i >0){
    print(paste(i, 'is less than 25, an integer and positive.', sep =''))
  }else if(i<25 & i %% 1 != 0){
    print(paste(i, 'is not an integer.', sep =''))
  } else if(i>=25 & i %% 1 ==0){
    print(paste(i, ' is not less than 25.', sep = ''))
  } else {
    print(paste(i, ' is one of not <25, not an integer, not positive or any combination'))
  }
}




#---------------------------------- While Loops --------------------------------

#loop a section of code within {}, while loops use a conditional statement 
#instead of an interate. They continue to loop while the statement is TRUE


x <- 0
while(x < 5){
  x <- x + 1
  print(paste('The number is now ', x, sep = ''))
}
#it stops running after 5 iterations as it only runs when x<5
#x reaches a value of 5 as it adds 1 to x each iteration


x <- 1
while(x %% 5 != 0 | x %% 6 != 0 | x %% 7 != 0){
  x <- x + 1
}
print(paste('The lowest number that is a factor of 5, 6, 7 and 8 is ', x, sep = ''))

#while x is not divisible by 5, 6 or 7 add 1 until it is
#x %% 5 != 0 checks that x is not divisble by 5
#the code does not work if x=0 because you cannot divide 0


x <- 1
while(x < 10){
  x <- x - 1
}
#above would run indefinitely 

x <- 0.999
while(x >= 0.5) {
  x <- x^2
  print(x)
}


#--------------------------------- Functions -----------------------------------

powers <- function(x){
  y <- x ^ 2
  return(y)
}
powers(1)

powers(30)

powers(5189)

#creating a function called powers which squares the inputted number and saves it
#as y then prints it


powers <- function(x){ #naming our function
  y <- x ^ 2 #squaring the input x and saving it as y
  z <- x ^ 3 #cubing x and saving it as z
  return(c( y, z)) #output both y and z
}
powers(1)

powers(30)

powers(5189)

#same as above but it also cubes x and saves it as z and prints both y and z


#Default Inputs - function will assume the input is the default

powers <- function(x, y = 2){
  z <- x ^ y
  return(z)
}
powers(3) #in the function it defines y as 2 which is then used to square x (x^y)
#this will then square every input (x) and save it as z

powers(3, 3) #this is defining y as 3, therefore it cubes the input x (3)


Berd <- function(x = 'Bird'){
  paste('Bird', ' is the word', sep='')
}

Berd(Bird)

Berd <- function(x = 'Bird', y ='is the word'){
  if(y == 'is not the word'){
    print(paste(x, 'is not the word', sep=' '))
  }else{
    print('Bird is the word')
  }
}
#^final question before the big question time

Berd('Bird', 'is not the word')





#--------------------------------- Question Time -------------------------------
#1.
qnum <- c(1,1,3,5,8,13,21)
for (i in qnum){
  print(sqrt(i))
}

#2.
