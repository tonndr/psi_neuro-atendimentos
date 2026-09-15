# Sistema de Atendimentos Neuropsicológico

Sistema web completo para registro e controle de atendimentos de neuropsicólogos, baseado no fluxo de planilhas e com integração ao **Supabase**.

## Funcionalidades
- **Login Individual por Profissional**: Cada profissional possui seu acesso com senha.
- **Tipos de Atendimento**: 
  - Terapia (R$ 35,00)
  - Avaliação Psicológica (R$ 55,00)
- **Inserção Manual de Pacientes**: Nome do paciente por horário e dia.
- **Controle de Faltas**: Atendido, Faltou (Remunerada) ou Faltou (Não remunerada).
- **Inativação de Horários e Dias**: Horários de pausa (ex: 12:00 - 13:30) inativos por padrão, além da opção "Não há atendimento" por dia.
- **Resumo Financeiro Automático**: 
  - Somatório de atendimentos e valores por tipo.
  - Checkbox **"Desconto de Serviço"** (deduz 15.33% do valor total).
- **Visualização Semanal e Mensal**: Navegação por semanas e meses, espelhando a planilha de controle.
- **Banco de Dados Supabase**: Armazenamento seguro na nuvem com modo offline (LocalStorage) de demonstração caso o Supabase não esteja configurado.

---

## Como Configurar o Supabase

1. Crie um projeto gratuito no [Supabase](https://supabase.com).
2. Vá em **SQL Editor** e execute o script contido no arquivo `schema.sql`.
3. Copie a **URL do Projeto** (`SUPABASE_URL`) e a **Chave Anon** (`SUPABASE_ANON_KEY`).
4. No sistema web, clique no botão **"Configurar Supabase"** no topo da tela e insira suas credenciais.

---

## Como Publicar no GitHub e Hospedar Grátis

1. Crie um repositório no GitHub (ex: `neuro-atendimentos`).
2. Envie os arquivos do projeto (`index.html`, `schema.sql`, `README.md`) para o repositório.
3. Ative o **GitHub Pages** nas configurações do repositório (apontando para a branch `main` / `root`) ou publique gratuitamente na **Vercel** ou **Netlify**.
