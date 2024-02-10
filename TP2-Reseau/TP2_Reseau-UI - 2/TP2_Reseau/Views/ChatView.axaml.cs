using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using TP2_Reseau.Encryption;
using TP2_Reseau.ViewModels;
using TP2_Reseau.Services;

namespace TP2_Reseau.Views;

public partial class ChatView : Window
{
    public ChatView()
    {
        InitializeComponent();
        DataContext = new ChatViewModel();
    }
}