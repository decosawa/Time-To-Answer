prawn_document do |pdf|

    pdf.text 'Listagem de Assuntos/Áreas', :align => :center, :size => 20
    pdf.move_down 20
    pdf.table @subjects.collect{|s| [s.id, s.description, s.questions.count]}.insert(0, ['ID', 'Assunto', 'Quantidade de Questões'])

end