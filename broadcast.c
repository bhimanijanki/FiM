/*
 * broadcast.c
 * Author: Janki Bhimani
 *
 */

#include <stdio.h>
#include <math.h>
#include "rngs.h"                      /* the multi-stream generator */

#define START         0.0              /* initial time                   */
#define STOP      200000000000000.0              /* terminal (close the door) time */
#define LARGE   (100.0 * STOP)      /* must be much larger than STOP  */


   double Min(double a, double c)
/* ------------------------------
 * return the smaller of a, b
 * ------------------------------
 */
{ 
  if (a < c)
    return (a);
  else
    return (c);
} 


   double Exponential(double m)
/* ---------------------------------------------------
 * generate an Exponential random variate, use m > 0.0 
 * ---------------------------------------------------
 */
{
  return (-m * log(1.0 - Random()));
}


   double Uniform(double a, double b)
/* --------------------------------------------
 * generate a Uniform random variate, use a < b 
 * --------------------------------------------
 */
{
  return (a + (b - a) * Random());
}


   double GetArrival()
/* ---------------------------------------------
 * generate the next arrival time, with rate 1/2
 * ---------------------------------------------
 */ 
{
  static double arrival = START;

  SelectStream(0); 
  //arrival += Uniform(0.032097524461003477,0.32);
  arrival += Uniform(0.0016097524461003477,0.016);
  return (arrival);
} 


   double GetService()
/* --------------------------------------------
 * generate the next service time with rate 2/3
 * --------------------------------------------
 */ 
{
  SelectStream(1);
  return Exponential(0.054);
}  


  int main(int argc, char *argv[])
{
  struct {
    double arrival;                 /* next arrival time                   */
    double completion;              /* next completion time                */
    double current;                 /* current time                        */
    double next;                    /* next (most imminent) event time     */
    double last;                    /* last arrival time                   */
  } t;
  struct {
    double node;                    /* time integrated number in the node  */
    double queue;                   /* time integrated number in the queue */
    double service;                 /* time integrated number in service   */
  } area      = {0.0, 0.0, 0.0};
  long index  = 0;                  /* used to count departed jobs         */
  long number = 0;                  /* number in the node                  */

  PlantSeeds(123456789);
  t.current    = START;           /* set the clock                         */
  t.arrival    = GetArrival();    /* schedule the first arrival            */
  t.completion = LARGE;        /* the first event can't be a completion */
 long LAST = atoi(argv[1]); 
long time;                     
  while (index < LAST) {
    t.next          = Min(t.arrival, t.completion);  /* next event time   */
	//printf("%ld\n",(number-1));
    if (number > 0)  {                               /* update integrals  */
      area.node    += (t.next - t.current) * number;
      area.queue   += (t.next - t.current) * (number - 1);
      area.service += (t.next - t.current);
    }
    t.current       = t.next;                    /* advance the clock */

    if (t.current == t.arrival)  {               /* process an arrival */
      number++;
      t.arrival     = GetArrival();
	    //if (number > 0)  {
	//	t.arrival = t.arrival + (log(number-1)*0.106);
	//	}
      if (t.arrival > STOP)  {
        t.last      = t.current;
        t.arrival   = LARGE;
      }
      if (number == 1)
        t.completion = t.current + GetService();
    }

    else {                                        /* process a completion */
      index++;
      number--;
      if (number > 0)
       {

	if(number!=1)
	{ 
		t.completion = t.current + GetService() + (0.1*log(number-1));
	}
	else
	{
		t.completion = t.current + GetService();
	}
	time = t.completion;}
      else
        t.completion = LARGE;
    }
  } 
	SelectStream(10); 
//	time +=  (Exponential(0.005)*LAST);
	time +=  (Exponential(1.3)*LAST);
   printf("   Time ............. = %f\n", time*1e-5);
  printf("\nfor %ld jobs\n", index);
  printf("   average interarrival time = %6.2f\n", t.last / index);
  //printf("   average wait ............ = %6.2f\n", area.node / index);
  //printf("   average delay ........... = %6.2f\n", area.queue / index);
  printf("   average service time .... = %6.2f\n", area.service / index);
  //printf("   average # in the node ... = %6.2f\n", area.node / t.current);
  //printf("   average # in the queue .. = %6.2f\n", area.queue / t.current);
  printf("   utilization ............. = %6.2f\n", area.service / t.current);

  return (0);
}
