program main
   use yafyaml, only : Parser, Configuration, FileStream
   implicit none

   type dag_t
     integer vertices
   end type

   type(Parser) p
   type(Configuration) c
   type(dag_t) dag

   p = Parser('core')
   c = p%load(FileStream('nested-objects.json'))
   dag%vertices = c%at('dag.vertices')

   if (dag%vertices /= 1) error stop "Test failed"

   sync all
   if (this_image()==1) print *,"Test passed"
end program
