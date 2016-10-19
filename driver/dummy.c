#include <stdlib.h>
#include <unistd.h>
#include "defs.h"
#include "vm.h"
#include "bbq.h"
#include "driver.h"
extern m_bool ssp_is_running;

//void no_wakeup(){}
static void dummy_run(VM* vm, DriverInfo* di)
{
  vm->bbq->in = calloc(vm->bbq->sp->nchan, sizeof(SPFLOAT));
  while(ssp_is_running)
  {
    vm_run(vm);
    vm->bbq->sp->pos++;
  }
}

static void silent_run(VM* vm, DriverInfo* di)
{
  m_uint timer = (vm->bbq->sp->sr / 100000);
  vm->bbq->in = calloc(vm->bbq->sp->nchan, sizeof(SPFLOAT));
  while(ssp_is_running)
  {
    vm_run(vm);
    vm->bbq->sp->pos++;
    usleep(timer);
  }
}

static m_bool dummy_ini(VM* vm, DriverInfo* di){}
static void dummy_del(VM* vm){}

Driver* silent_driver(VM* vm)
{
  Driver* d = malloc(sizeof(Driver));
  d->ini = dummy_ini;
  d->run = silent_run;
  d->del = dummy_del;
	vm->wakeup = no_wakeup;
  return d;
}

Driver* dummy_driver(VM* vm)
{
  Driver* d = malloc(sizeof(Driver));
  d->ini = dummy_ini;
  d->run = dummy_run;
  d->del = dummy_del;
	vm->wakeup = no_wakeup;
  return d;
}
