class AdminsBackoffice::AdminsController < AdminsBackofficeController

  def index

    @admins = Admin.all

  end

  def edit 

    @admin = Admin.find(params[:id])

  end

  def update

    admin = Admin.find(params[:id])
    p_admin = params.require(:admin).permit(:email, :password, :password_confirmation)

    if(admin.update(p_admin))

      redirect_to admins_backoffice_admins_path, notice: "Administrador atualizado com sucesso!"
    
    else

      render :edit, notice: "Administrador não atualizado"

    end

  end

end
